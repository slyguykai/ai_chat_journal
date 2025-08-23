//
//  SwiftDataEntryStore.swift
//  AI Journal App
//
//  SwiftData implementation of EntryStore
//

import Foundation
import SwiftData

/// SwiftData implementation of EntryStore
class SwiftDataEntryStore: EntryStore {
    @Published var entries: [JournalEntry] = []
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        Task {
            await loadEntries()
        }
    }
    
    // MARK: - EntryStore Protocol
    
    func addEntry(_ entry: JournalEntry) async throws {
        let swiftDataEntry = entry.toSwiftDataEntry()
        
        await MainActor.run {
            modelContext.insert(swiftDataEntry)
        }
        
        try await saveContext()
        await loadEntries()
    }
    
    func updateEntry(_ entry: JournalEntry) async throws {
        let predicate = #Predicate<Entry> { $0.id == entry.id }
        let descriptor = FetchDescriptor<Entry>(predicate: predicate)
        
        let existingEntries = try await MainActor.run {
            try modelContext.fetch(descriptor)
        }
        
        guard let existingEntry = existingEntries.first else {
            throw EntryStoreError.entryNotFound
        }
        
        await MainActor.run {
            existingEntry.text = entry.text
            existingEntry.mood = entry.mood.map { Double($0.moodScore) }
            existingEntry.summary = entry.summary
        }
        
        try await saveContext()
        await loadEntries()
    }
    
    func deleteEntry(id: UUID) async throws {
        let predicate = #Predicate<Entry> { $0.id == id }
        let descriptor = FetchDescriptor<Entry>(predicate: predicate)
        
        let entries = try await MainActor.run {
            try modelContext.fetch(descriptor)
        }
        
        guard let entryToDelete = entries.first else {
            throw EntryStoreError.entryNotFound
        }
        
        await MainActor.run {
            modelContext.delete(entryToDelete)
        }
        
        try await saveContext()
        await loadEntries()
    }
    
    func fetchEntries() async throws {
        await loadEntries()
    }
    
    // MARK: - Private Methods
    
    private func loadEntries() async {
        do {
            let descriptor = FetchDescriptor<Entry>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            
            let swiftDataEntries = try await MainActor.run {
                try modelContext.fetch(descriptor)
            }
            
            let journalEntries = swiftDataEntries.map { $0.toJournalEntry() }
            
            await MainActor.run {
                self.entries = journalEntries
            }
        } catch {
            print("Failed to load entries: \(error)")
            await MainActor.run {
                self.entries = []
            }
        }
    }
    
    private func saveContext() async throws {
        try await MainActor.run {
            try modelContext.save()
        }
    }
}

// MARK: - Error Types

enum EntryStoreError: Error, LocalizedError {
    case entryNotFound
    case saveFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .entryNotFound:
            return "Entry not found"
        case .saveFailed(let error):
            return "Save failed: \(error.localizedDescription)"
        }
    }
}
