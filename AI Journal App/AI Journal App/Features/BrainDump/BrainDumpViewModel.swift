//
//  BrainDumpViewModel.swift
//  AI Journal App
//
//  ViewModel for brain dump feature with state machine
//

import Foundation

/// Brain dump state machine states
enum BrainDumpState: Equatable {
    case idle
    case editing(text: String)
    case saving
    case saved
    case error(message: String)
    
    var isEditing: Bool {
        if case .editing = self { return true }
        return false
    }
    
    var isSaving: Bool {
        if case .saving = self { return true }
        return false
    }
    
    var canSave: Bool {
        if case .editing(let text) = self {
            return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }
    
    var currentText: String {
        if case .editing(let text) = self { return text }
        return ""
    }
}

/// ViewModel for brain dump feature
@MainActor
class BrainDumpViewModel: ObservableObject {
    @Published var state: BrainDumpState = .idle
    
    private let entryStore: any EntryStore
    
    init(entryStore: any EntryStore) {
        self.entryStore = entryStore
    }
    
    // MARK: - Public Methods
    
    func startEditing() {
        state = .editing(text: "")
    }
    
    func updateText(_ text: String) {
        state = .editing(text: text)
    }
    
    func save() {
        guard case .editing(let text) = state else { return }
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        state = .saving
        
        Task {
            do {
                let entry = JournalEntry(text: trimmedText)
                try await entryStore.addEntry(entry)
                state = .saved
                
                // Reset to idle after brief delay
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
                state = .idle
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }
    
    func dismissError() {
        if case .error = state {
            state = .idle
        }
    }
    
    func reset() {
        state = .idle
    }
    
    // MARK: - Computed Properties
    
    var characterCount: Int {
        state.currentText.count
    }
    
    var canSave: Bool {
        state.canSave
    }
    
    var isLoading: Bool {
        state.isSaving
    }
}
