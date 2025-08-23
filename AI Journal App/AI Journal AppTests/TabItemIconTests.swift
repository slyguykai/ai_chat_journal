//
//  TabItemIconTests.swift
//  AI Journal AppTests
//

import XCTest
@testable import AI_Journal_App

final class TabItemIconTests: XCTestCase {
    func testTabItemIconsResolveToValidSFSymbols() {
        for item in TabItem.allCases {
            let name = item.icon.rawValue
            XCTAssertNotNil(UIImage(systemName: name), "SF Symbol not found for \(item): \(name)")
        }
    }
}


