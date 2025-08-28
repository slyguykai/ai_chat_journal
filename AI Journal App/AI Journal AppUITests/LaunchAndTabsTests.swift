//
//  LaunchAndTabsTests.swift
//  AI Journal AppUITests
//
//  UI tests for app launch and tab navigation
//

import XCTest

final class LaunchAndTabsTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAppLaunchAndTabsExist() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test that the app launches successfully
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
        
        // Test that tab bar exists
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
        
        // Test that Today tab exists and is initially selected
        let todayTab = tabBar.buttons["Today view"]
        XCTAssertTrue(todayTab.exists, "Today tab should exist")
        
        // Test that Library tab exists
        let libraryTab = tabBar.buttons["Library view"]
        XCTAssertTrue(libraryTab.exists, "Library tab should exist")
        
        // Navigate to Library and back to Today
        libraryTab.tap()
        XCTAssertTrue(libraryTab.isSelected, "Library tab should be selected after tap")
        todayTab.tap()
        XCTAssertTrue(todayTab.isSelected, "Today tab should be selected after tap")
    }
    
    func testBrainDumpFlowSavesEntry() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the floating CTA to open Brain Dump
        let brainDumpCTA = app.buttons["Brain dump view"]
        XCTAssertTrue(brainDumpCTA.waitForExistence(timeout: 3), "Floating CTA should exist")
        brainDumpCTA.tap()
        
        // Interact with the editor
        let editor = app.textViews.firstMatch
        XCTAssertTrue(editor.waitForExistence(timeout: 3), "Brain Dump editor should exist")
        editor.tap()
        editor.typeText("UITest entry from UI test")
        
        // Save the entry via keyboard toolbar button
        let saveButton = app.buttons["Save entry"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3), "Save button should exist")
        saveButton.tap()
        
        // Navigate to Library and verify the entry appears
        let libraryTab = app.tabBars.firstMatch.buttons["Library view"]
        XCTAssertTrue(libraryTab.exists)
        libraryTab.tap()
        
        let newEntry = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "UITest entry")).firstMatch
        XCTAssertTrue(newEntry.waitForExistence(timeout: 5), "Newly saved entry should appear in Library")
    }

    func testBrainDumpControlsProgressiveDisclosure() throws {
        let app = XCUIApplication()
        app.launch()

        // Open Brain Dump via floating CTA
        let brainDumpCTA = app.buttons["Brain dump view"]
        XCTAssertTrue(brainDumpCTA.waitForExistence(timeout: 3))
        brainDumpCTA.tap()

        // Focus the editor to bring up the keyboard toolbar
        let editor = app.textViews.firstMatch
        XCTAssertTrue(editor.waitForExistence(timeout: 3))
        editor.tap()

        // Identify toolbar controls (now that keyboard is up)
        let saveButton = app.buttons["save_entry_button"]
        let micButton = app.buttons["mic_button"]
        let happyMood = app.buttons["mood_happy_button"]

        // Controls exist but are not hittable until user types
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        XCTAssertFalse(saveButton.isHittable, "Save should be hidden before typing")
        XCTAssertTrue(micButton.exists)
        XCTAssertFalse(micButton.isHittable, "Mic should be hidden before typing")
        XCTAssertTrue(happyMood.exists)
        XCTAssertFalse(happyMood.isHittable, "Mood buttons should be hidden before typing")

        // Type a character to reveal controls
        editor.typeText("a")

        // Controls become visible and hittable (allow short animation)
        let enabledPredicate = NSPredicate(format: "isEnabled == true")
        expectation(for: enabledPredicate, evaluatedWith: saveButton)
        expectation(for: enabledPredicate, evaluatedWith: micButton)
        expectation(for: enabledPredicate, evaluatedWith: happyMood)
        waitForExpectations(timeout: 3)
    }
}
