//
//  LibraryViewModelTests.swift
//  AI Journal AppTests
//

import XCTest
@testable import AI_Journal_App

@MainActor
final class LibraryViewModelTests: XCTestCase {
    func testLoadAndSearchFiltersByTextAndSummary() async {
        let store = MockEntryStore()
        store.entries = [
            JournalEntry(text: "Went for a jog in the park", summary: "Jogging"),
            JournalEntry(text: "Cooked pasta for dinner", summary: nil),
            JournalEntry(text: "Read a book about Swift", summary: "Swift reading")
        ]
        let vm = LibraryViewModel(entryStore: store)
        await vm.load()
        XCTAssertEqual(vm.filtered.count, 3)

        vm.searchText = "pasta"
        XCTAssertEqual(vm.filtered.count, 1)
        XCTAssertTrue(vm.filtered.first?.text.contains("pasta") == true)

        vm.searchText = "swift"
        XCTAssertEqual(vm.filtered.count, 1)
        XCTAssertEqual(vm.filtered.first?.summary, "Swift reading")

        vm.searchText = ""
        XCTAssertEqual(vm.filtered.count, 3)
    }
}

