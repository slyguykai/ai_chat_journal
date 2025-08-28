//
//  SpeechTranscriber.swift
//  AI Journal App
//
//  Minimal speech-to-text helper using AVAudioEngine + SFSpeechRecognizer
//

import Foundation
import AVFoundation
import Speech

final class SpeechTranscriber: NSObject {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let recognizer = SFSpeechRecognizer()
    
    var onPartial: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    func start() async throws {
        // Permissions
        let mic = await PermissionManager.requestMicrophone()
        let speech = await PermissionManager.requestSpeechRecognition()
        guard mic == .authorized, speech == .authorized else {
            throw NSError(domain: "SpeechTranscriber", code: 1, userInfo: [NSLocalizedDescriptionKey: "Microphone or speech permission denied"])
        }
        
        // Configure audio session
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Build recognition request
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request
        
        // Install tap on input node
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        // Start audio
        audioEngine.prepare()
        try audioEngine.start()
        
        // Start recognition task
        guard let recognizer, recognizer.isAvailable else {
            throw NSError(domain: "SpeechTranscriber", code: 2, userInfo: [NSLocalizedDescriptionKey: "Speech recognizer unavailable"])
        }
        
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let error { self?.onError?(error) }
            if let result {
                let text = result.bestTranscription.formattedString
                self?.onPartial?(text)
                if result.isFinal { self?.stop() }
            }
        }
    }
    
    func stop() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        if audioEngine.isRunning { audioEngine.stop() }
        audioEngine.inputNode.removeTap(onBus: 0)
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

