//
//  EntryListViewModel.swift
//  AI Journal App
//
//  ViewModel for managing journal entry list state
//

import Foundation

/// ViewModel for journal entry list
@MainActor
class EntryListViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let entryStore: any EntryStore
    
    init(entryStore: any EntryStore) {
        self.entryStore = entryStore
        loadEntries()
    }
    
    // MARK: - Public Methods
    
    func loadEntries() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                try await entryStore.fetchEntries()
                await updateEntries()
            } catch {
                errorMessage = "Failed to load entries: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        Task {
            do {
                try await entryStore.deleteEntry(id: entry.id)
                await updateEntries()
            } catch {
                errorMessage = "Failed to delete entry: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateEntries() async {
        entries = entryStore.entries.sorted { $0.timestamp > $1.timestamp }
    }
}
