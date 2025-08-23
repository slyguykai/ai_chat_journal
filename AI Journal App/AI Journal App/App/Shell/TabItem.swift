//
//  TabItem.swift
//  AI Journal App
//
//  Centralized tab metadata
//

import SwiftUI

enum TabItem: String, CaseIterable, Identifiable {
    case today
    case inspire
    case brainDump
    case library
    case stats
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .today: return "Today"
        case .inspire: return "Inspire"
        case .brainDump: return "Brain Dump"
        case .library: return "Library"
        case .stats: return "Stats"
        }
    }
    
    var systemImage: String {
        switch self {
        case .today: return "house"
        case .inspire: return "sparkles"
        case .brainDump: return "plus.circle.fill"
        case .library: return "books.vertical"
        case .stats: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .today: return "Today view"
        case .inspire: return "Inspire view"
        case .brainDump: return "Brain dump view"
        case .library: return "Library view"
        case .stats: return "Statistics view"
        }
    }
    
    var accessibilityHint: String {
        switch self {
        case .today: return "See today's prompts and streak"
        case .inspire: return "Browse inspiration prompts"
        case .brainDump: return "Capture a new reflection"
        case .library: return "Browse your saved entries"
        case .stats: return "View mood trends and insights"
        }
    }
}

