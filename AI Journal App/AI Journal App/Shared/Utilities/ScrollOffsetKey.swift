//
//  ScrollOffsetKey.swift
//  AI Journal App
//
//  PreferenceKey to propagate vertical scroll offset
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
