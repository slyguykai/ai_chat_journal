//
//  SystemIcon.swift
//  AI Journal App
//
//  Centralized, type-safe SF Symbols usage with a safe fallback initializer.
//

import SwiftUI
import UIKit

enum SystemIcon: String {
    case house
    case sparkles
    case plusCircleFill = "plus.circle.fill"
    case booksVertical = "books.vertical"
    case chartLineUptrendXYAxis = "chart.line.uptrend.xyaxis"
    case magnifyingglass
    case xmark
    case checkmark
    case questionmark
    case chevronLeft = "chevron.left"
    case book
    case ellipsis
    case faceSmiling = "face.smiling"
    case faceDashed = "face.dashed"
    case heartFill = "heart.fill"
    case lockShield = "lock.shield"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case xmarkCircleFill = "xmark.circle.fill"
    case circle
    case minus
    case trash
    case bookClosed = "book.closed"
    case flameFill = "flame.fill"
    case leafFill = "leaf.fill"
}

extension Image {
    init(system icon: SystemIcon) {
        self.init(systemName: icon.rawValue)
    }
}

extension Image {
    static func safeSystem(_ name: String?, default fallback: SystemIcon = .questionmark) -> Image {
        guard let n = name, !n.isEmpty, UIImage(systemName: n) != nil else {
            return Image(system: fallback)
        }
        return Image(systemName: n)
    }
}
