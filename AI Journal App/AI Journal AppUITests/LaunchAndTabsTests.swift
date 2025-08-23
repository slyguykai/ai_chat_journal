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
        
        // Test tab navigation
        libraryTab.tap()
        XCTAssertTrue(libraryTab.isSelected, "Library tab should be selected after tap")
        
        // Test Quick Add button exists
        let quickAddTab = tabBar.buttons["Quick add entry"]
        XCTAssertTrue(quickAddTab.exists, "Quick Add tab should exist")
    }
    
    func testQuickAddFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.firstMatch
        let quickAddTab = tabBar.buttons["Quick add entry"]
        
        // Tap Quick Add
        quickAddTab.tap()
        
        // Verify sheet appears
        let quickEntryText = app.staticTexts["Quick Entry"]
        XCTAssertTrue(quickEntryText.waitForExistence(timeout: 2), "Quick Entry sheet should appear")
        
        // Test Cancel button
        let cancelButton = app.buttons["Cancel entry"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should exist")
        cancelButton.tap()
        
        // Verify sheet dismisses
        XCTAssertFalse(quickEntryText.exists, "Quick Entry sheet should dismiss")
    }
}
