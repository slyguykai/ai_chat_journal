//
//  PermissionManager.swift
//  AI Journal App
//
//  Permission management for microphone, speech recognition, and notifications
//

import Foundation
import AVFoundation
import Speech
import UserNotifications

/// Permission types supported by the app
enum PermissionType {
    case microphone
    case speechRecognition
    case notifications
}

/// Permission status
enum PermissionStatus {
    case notDetermined
    case denied
    case authorized
    case restricted
}

/// Manager for handling app permissions
struct PermissionManager {
    
    // MARK: - Microphone Permission
    
    /// Request microphone permission for voice recording
    static func requestMicrophone() async -> PermissionStatus {
        return await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                let status: PermissionStatus = granted ? .authorized : .denied
                continuation.resume(returning: status)
            }
        }
    }
    
    /// Check current microphone permission status
    static func microphoneStatus() -> PermissionStatus {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            return .authorized
        case .denied:
            return .denied
        case .undetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
    
    // MARK: - Speech Recognition Permission
    
    /// Request speech recognition permission for transcription
    static func requestSpeechRecognition() async -> PermissionStatus {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                let permissionStatus: PermissionStatus
                switch status {
                case .authorized:
                    permissionStatus = .authorized
                case .denied:
                    permissionStatus = .denied
                case .restricted:
                    permissionStatus = .restricted
                case .notDetermined:
                    permissionStatus = .notDetermined
                @unknown default:
                    permissionStatus = .notDetermined
                }
                continuation.resume(returning: permissionStatus)
            }
        }
    }
    
    /// Check current speech recognition permission status
    static func speechRecognitionStatus() -> PermissionStatus {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
    
    // MARK: - Notifications Permission
    
    /// Request notification permission for reminders
    static func requestNotifications() async -> PermissionStatus {
        do {
            let center = UNUserNotificationCenter.current()
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            return granted ? .authorized : .denied
        } catch {
            print("Failed to request notification permission: \(error)")
            return .denied
        }
    }
    
    /// Check current notification permission status
    static func notificationStatus() async -> PermissionStatus {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .provisional:
            return .authorized
        case .ephemeral:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
    
    // MARK: - Convenience Methods
    
    /// Check if all required permissions are granted
    static func allPermissionsGranted() async -> Bool {
        let microphone = microphoneStatus() == .authorized
        let speech = speechRecognitionStatus() == .authorized
        let notifications = await notificationStatus() == .authorized
        
        return microphone && speech && notifications
    }
    
    /// Request all permissions sequentially
    static func requestAllPermissions() async -> [PermissionType: PermissionStatus] {
        var results: [PermissionType: PermissionStatus] = [:]
        
        results[.microphone] = await requestMicrophone()
        results[.speechRecognition] = await requestSpeechRecognition()
        results[.notifications] = await requestNotifications()
        
        return results
    }
}
