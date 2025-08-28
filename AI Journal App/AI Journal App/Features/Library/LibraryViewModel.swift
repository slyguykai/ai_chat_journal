//
//  LibraryViewModel.swift
//  AI Journal App
//
//  View model for the Library screen
//

import Foundation
import SwiftUI

@MainActor
final class LibraryViewModel: ObservableObject {
    @Published var searchText: String = "" { didSet { filterEntries() } }
    @Published private(set) var entries: [JournalEntry] = []
    @Published private(set) var filtered: [JournalEntry] = []
    
    let entryStore: any EntryStore
    
    init(entryStore: any EntryStore) {
        self.entryStore = entryStore
    }
    
    func load() async {
        do {
            try await entryStore.fetchEntries()
            entries = entryStore.entries.sorted { $0.timestamp > $1.timestamp }
            filterEntries()
        } catch {
            // For now, ignore errors for mock store
        }
    }
    
    func delete(_ entry: JournalEntry) async {
        do {
            try await entryStore.deleteEntry(id: entry.id)
            await load()
        } catch {
            // Intentionally ignore for now; could surface an error state
        }
    }
    
    private func filterEntries() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            filtered = entries
            return
        }
        filtered = entries.filter { $0.text.localizedCaseInsensitiveContains(query) || ($0.summary ?? "").localizedCaseInsensitiveContains(query) }
    }
}
