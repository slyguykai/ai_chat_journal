//
//  EntryStore.swift
//  AI Journal App
//
//  Journal entry storage protocol and model
//

import Foundation

/// Journal entry model
struct JournalEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let timestamp: Date
    let text: String
    let mood: MoodType?
    let summary: String?
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        text: String,
        mood: MoodType? = nil,
        summary: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.text = text
        self.mood = mood
        self.summary = summary
    }
}

/// Protocol for journal entry storage operations
protocol EntryStore: ObservableObject {
    var entries: [JournalEntry] { get }
    
    func addEntry(_ entry: JournalEntry) async throws
    func updateEntry(_ entry: JournalEntry) async throws
    func deleteEntry(id: UUID) async throws
    func fetchEntries() async throws
}
