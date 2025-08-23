//
//  Entry.swift
//  AI Journal App
//
//  SwiftData model for journal entries
//

import Foundation
import SwiftData

/// SwiftData model for journal entries
@Model
final class Entry {
    @Attribute(.unique) var id: UUID
    var text: String
    var mood: Double?
    var createdAt: Date
    var summary: String?
    
    init(id: UUID = UUID(), text: String, mood: Double? = nil, createdAt: Date = Date(), summary: String? = nil) {
        self.id = id
        self.text = text
        self.mood = mood
        self.createdAt = createdAt
        self.summary = summary
    }
}

// MARK: - Conversion Extensions

extension Entry {
    /// Convert SwiftData Entry to JournalEntry
    func toJournalEntry() -> JournalEntry {
        let moodType: MoodType? = {
            guard let mood = mood else { return nil }
            switch mood {
            case 0..<2: return .sad
            case 2..<4: return .neutral
            case 4..<6: return .happy
            case 6..<8: return .excited
            case 8...10: return .love
            default: return .neutral
            }
        }()
        
        return JournalEntry(
            id: id,
            timestamp: createdAt,
            text: text,
            mood: moodType,
            summary: summary
        )
    }
}

extension JournalEntry {
    /// Convert JournalEntry to SwiftData Entry
    func toSwiftDataEntry() -> Entry {
        let moodValue: Double? = mood.map { Double($0.moodScore) }
        
        return Entry(
            id: id,
            text: text,
            mood: moodValue,
            createdAt: timestamp,
            summary: summary
        )
    }
}
