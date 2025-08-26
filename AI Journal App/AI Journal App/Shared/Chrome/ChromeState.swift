//
//  ChromeState.swift
//  AI Journal App
//
//  Shared chrome state: keyboard + condensed tab bar
//

import SwiftUI

@Observable class ChromeState {
    var isKeyboardUp: Bool = false
    var condensedTab: Bool = false
    init() {}
}
