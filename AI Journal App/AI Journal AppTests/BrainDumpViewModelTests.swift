//
//  BrainDumpViewModelTests.swift
//  AI Journal AppTests
//
//  Unit tests for BrainDumpViewModel state machine
//

import XCTest
@testable import AI_Journal_App

@MainActor
final class BrainDumpViewModelTests: XCTestCase {
    
    var mockStore: MockEntryStore!
    var viewModel: BrainDumpViewModel!
    
    override func setUp() {
        super.setUp()
        mockStore = MockEntryStore()
        viewModel = BrainDumpViewModel(entryStore: mockStore)
    }
    
    override func tearDown() {
        viewModel = nil
        mockStore = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertFalse(viewModel.canSave)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.characterCount, 0)
    }
    
    // MARK: - State Transition Tests
    
    func testStartEditing() {
        viewModel.startEditing()
        XCTAssertEqual(viewModel.state, .editing(text: ""))
        XCTAssertFalse(viewModel.canSave) // Empty text shouldn't be savable
    }
    
    func testUpdateText() {
        viewModel.startEditing()
        viewModel.updateText("Hello world")
        
        XCTAssertEqual(viewModel.state, .editing(text: "Hello world"))
        XCTAssertTrue(viewModel.canSave)
        XCTAssertEqual(viewModel.characterCount, 11)
    }
    
    func testUpdateTextWithEmptyString() {
        viewModel.startEditing()
        viewModel.updateText("   ")
        
        XCTAssertEqual(viewModel.state, .editing(text: "   "))
        XCTAssertFalse(viewModel.canSave) // Whitespace only shouldn't be savable
    }
    
    func testSaveWithValidText() async {
        let initialEntryCount = mockStore.entries.count
        
        viewModel.startEditing()
        viewModel.updateText("This is a test entry")
        
        XCTAssertTrue(viewModel.canSave)
        
        viewModel.save()
        XCTAssertEqual(viewModel.state, .saving)
        XCTAssertTrue(viewModel.isLoading)
        
        // Wait for save operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        XCTAssertEqual(viewModel.state, .saved)
        XCTAssertEqual(mockStore.entries.count, initialEntryCount + 1)
        
        // Verify the entry was added with correct text
        let addedEntry = mockStore.entries.first { $0.text == "This is a test entry" }
        XCTAssertNotNil(addedEntry)
    }
    
    func testSaveWithEmptyTextDoesNothing() {
        let initialEntryCount = mockStore.entries.count
        
        viewModel.startEditing()
        viewModel.updateText("")
        viewModel.save()
        
        // Should not transition to saving state
        XCTAssertEqual(viewModel.state, .editing(text: ""))
        XCTAssertEqual(mockStore.entries.count, initialEntryCount)
    }
    
    func testSaveFromNonEditingStateDoesNothing() {
        let initialEntryCount = mockStore.entries.count
        
        // Try to save from idle state
        viewModel.save()
        
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertEqual(mockStore.entries.count, initialEntryCount)
    }
    
    func testReset() {
        viewModel.startEditing()
        viewModel.updateText("Some text")
        viewModel.reset()
        
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertFalse(viewModel.canSave)
        XCTAssertEqual(viewModel.characterCount, 0)
    }
    
    func testDismissError() {
        // Simulate error state
        viewModel.state = .error(message: "Test error")
        
        viewModel.dismissError()
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    // MARK: - State Property Tests
    
    func testStateProperties() {
        // Test idle state
        viewModel.state = .idle
        XCTAssertFalse(viewModel.state.isEditing)
        XCTAssertFalse(viewModel.state.isSaving)
        XCTAssertFalse(viewModel.state.canSave)
        XCTAssertEqual(viewModel.state.currentText, "")
        
        // Test editing state
        viewModel.state = .editing(text: "Test")
        XCTAssertTrue(viewModel.state.isEditing)
        XCTAssertFalse(viewModel.state.isSaving)
        XCTAssertTrue(viewModel.state.canSave)
        XCTAssertEqual(viewModel.state.currentText, "Test")
        
        // Test saving state
        viewModel.state = .saving
        XCTAssertFalse(viewModel.state.isEditing)
        XCTAssertTrue(viewModel.state.isSaving)
        XCTAssertFalse(viewModel.state.canSave)
        
        // Test saved state
        viewModel.state = .saved
        XCTAssertFalse(viewModel.state.isEditing)
        XCTAssertFalse(viewModel.state.isSaving)
        XCTAssertFalse(viewModel.state.canSave)
        
        // Test error state
        viewModel.state = .error(message: "Error")
        XCTAssertFalse(viewModel.state.isEditing)
        XCTAssertFalse(viewModel.state.isSaving)
        XCTAssertFalse(viewModel.state.canSave)
    }
}
