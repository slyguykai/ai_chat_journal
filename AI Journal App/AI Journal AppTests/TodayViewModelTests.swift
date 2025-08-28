//
//  TodayViewModelTests.swift
//  AI Journal AppTests
//

import XCTest
@testable import AI_Journal_App

@MainActor
final class TodayViewModelTests: XCTestCase {
    func testHasEntryTodayFalseWhenNoEntries() async {
        let store = MockEntryStore()
        store.entries = []
        let vm = TodayViewModel(entryStore: store)
        await vm.refresh()
        XCTAssertFalse(vm.hasEntryToday)
    }

    func testHasEntryTodayTrueWhenEntryExists() async {
        let store = MockEntryStore()
        let today = Date()
        store.entries = [
            JournalEntry(timestamp: Calendar.current.date(byAdding: .day, value: -1, to: today)!, text: "yesterday"),
            JournalEntry(timestamp: today, text: "today")
        ]
        let vm = TodayViewModel(entryStore: store)
        await vm.refresh()
        XCTAssertTrue(vm.hasEntryToday)
    }
}

