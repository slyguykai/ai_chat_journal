//
//  MockEntryStore.swift
//  AI Journal App
//
//  In-memory implementation of EntryStore for development/testing
//

import Foundation

/// Mock implementation of EntryStore with sample data
@MainActor
class MockEntryStore: EntryStore {
    @Published var entries: [JournalEntry] = []
    
    init() {
        loadMockData()
    }
    
    func addEntry(_ entry: JournalEntry) async throws {
        entries.insert(entry, at: 0)
    }
    
    func updateEntry(_ entry: JournalEntry) async throws {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        }
    }
    
    func deleteEntry(id: UUID) async throws {
        entries.removeAll { $0.id == id }
    }
    
    func fetchEntries() async throws {
        // Mock async delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
    }
    
    // MARK: - Mock Data
    
    private func loadMockData() {
        let calendar = Calendar.current
        let now = Date()
        
        entries = [
            JournalEntry(
                timestamp: now,
                text: "Had a great morning walk. The sunrise was beautiful and I felt so peaceful.",
                mood: .happy,
                summary: "Morning walk with beautiful sunrise"
            ),
            JournalEntry(
                timestamp: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
                text: "Feeling overwhelmed with work today. Too many meetings and deadlines.",
                mood: .sad,
                summary: "Work stress and overwhelm"
            ),
            JournalEntry(
                timestamp: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                text: "Spent quality time with family. We played board games and laughed so much!",
                mood: .love,
                summary: "Quality family time with games"
            ),
            JournalEntry(
                timestamp: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                text: "Just finished reading an amazing book. Can't wait to start the next one in the series.",
                mood: .excited,
                summary: "Finished an amazing book"
            ),
            JournalEntry(
                timestamp: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                text: "Regular day at the office. Nothing particularly exciting or concerning.",
                mood: .neutral,
                summary: "Regular office day"
            )
        ]
    }
}
