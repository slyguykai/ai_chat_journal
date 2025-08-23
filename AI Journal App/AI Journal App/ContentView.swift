//
//  ContentView.swift
//  AI Journal App
//
//  Created by Kyle Malcolm on 8/20/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RootView()
    }
}

#Preview("App Shell - Light") {
    ContentView()
}

#Preview("App Shell - Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
