//
//  EntryDetailViewModel.swift
//  AI Journal App
//

import Foundation

@MainActor
final class EntryDetailViewModel: ObservableObject {
    @Published private(set) var entry: JournalEntry
    private let entryStore: any EntryStore
    
    init(entry: JournalEntry, entryStore: any EntryStore) {
        self.entry = entry
        self.entryStore = entryStore
    }
    
    func delete() async throws {
        try await entryStore.deleteEntry(id: entry.id)
    }
}
