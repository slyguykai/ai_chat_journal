//
//  EntryStoreSwiftDataTests.swift
//  AI Journal AppTests
//
//  Tests for SwiftDataEntryStore CRUD operations
//

import XCTest
import SwiftData
@testable import AI_Journal_App

@MainActor
final class EntryStoreSwiftDataTests: XCTestCase {
    
    var container: AppContainer!
    var entryStore: SwiftDataEntryStore!
    
    override func setUp() async throws {
        super.setUp()
        container = try AppContainer.inMemoryContainer()
        entryStore = container.entryStore as? SwiftDataEntryStore
        XCTAssertNotNil(entryStore, "Failed to create SwiftDataEntryStore")
    }
    
    override func tearDown() {
        entryStore = nil
        container = nil
        super.tearDown()
    }
    
    // MARK: - CRUD Tests
    
    func testAddEntry() async throws {
        let entry = JournalEntry(
            text: "Test entry",
            mood: .happy,
            summary: "Test summary"
        )
        
        let initialCount = entryStore.entries.count
        
        try await entryStore.addEntry(entry)
        
        XCTAssertEqual(entryStore.entries.count, initialCount + 1)
        
        let addedEntry = entryStore.entries.first { $0.id == entry.id }
        XCTAssertNotNil(addedEntry)
        XCTAssertEqual(addedEntry?.text, "Test entry")
        XCTAssertEqual(addedEntry?.mood, .happy)
        XCTAssertEqual(addedEntry?.summary, "Test summary")
    }
    
    func testUpdateEntry() async throws {
        let originalEntry = JournalEntry(
            text: "Original text",
            mood: .neutral,
            summary: "Original summary"
        )
        
        try await entryStore.addEntry(originalEntry)
        
        let updatedEntry = JournalEntry(
            id: originalEntry.id,
            timestamp: originalEntry.timestamp,
            text: "Updated text",
            mood: .excited,
            summary: "Updated summary"
        )
        
        try await entryStore.updateEntry(updatedEntry)
        
        let retrievedEntry = entryStore.entries.first { $0.id == originalEntry.id }
        XCTAssertNotNil(retrievedEntry)
        XCTAssertEqual(retrievedEntry?.text, "Updated text")
        XCTAssertEqual(retrievedEntry?.mood, .excited)
        XCTAssertEqual(retrievedEntry?.summary, "Updated summary")
    }
    
    func testDeleteEntry() async throws {
        let entry = JournalEntry(
            text: "Entry to delete",
            mood: .sad
        )
        
        try await entryStore.addEntry(entry)
        XCTAssertTrue(entryStore.entries.contains { $0.id == entry.id })
        
        try await entryStore.deleteEntry(id: entry.id)
        XCTAssertFalse(entryStore.entries.contains { $0.id == entry.id })
    }
    
    func testFetchEntries() async throws {
        // Add multiple entries
        let entries = [
            JournalEntry(text: "Entry 1", mood: .happy),
            JournalEntry(text: "Entry 2", mood: .neutral),
            JournalEntry(text: "Entry 3", mood: .love)
        ]
        
        for entry in entries {
            try await entryStore.addEntry(entry)
        }
        
        try await entryStore.fetchEntries()
        
        XCTAssertGreaterThanOrEqual(entryStore.entries.count, 3)
        
        // Verify entries are sorted by creation date (newest first)
        let timestamps = entryStore.entries.map { $0.timestamp }
        let sortedTimestamps = timestamps.sorted(by: >)
        XCTAssertEqual(timestamps, sortedTimestamps)
    }
    
    func testDeleteNonExistentEntry() async throws {
        let nonExistentId = UUID()
        
        do {
            try await entryStore.deleteEntry(id: nonExistentId)
            XCTFail("Expected EntryStoreError.entryNotFound")
        } catch EntryStoreError.entryNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testUpdateNonExistentEntry() async throws {
        let nonExistentEntry = JournalEntry(
            id: UUID(),
            text: "Non-existent entry"
        )
        
        do {
            try await entryStore.updateEntry(nonExistentEntry)
            XCTFail("Expected EntryStoreError.entryNotFound")
        } catch EntryStoreError.entryNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Data Conversion Tests
    
    func testMoodConversion() async throws {
        let testCases: [(MoodType, Double)] = [
            (.sad, 3.0),
            (.neutral, 5.0),
            (.happy, 8.0),
            (.excited, 9.0),
            (.love, 10.0)
        ]
        
        for (moodType, expectedValue) in testCases {
            let entry = JournalEntry(text: "Test \(moodType)", mood: moodType)
            try await entryStore.addEntry(entry)
            
            let retrievedEntry = entryStore.entries.first { $0.id == entry.id }
            XCTAssertNotNil(retrievedEntry)
            XCTAssertEqual(retrievedEntry?.mood, moodType)
        }
    }
}
