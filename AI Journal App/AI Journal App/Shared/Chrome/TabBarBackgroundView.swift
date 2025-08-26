//
//  TabBarBackgroundView.swift
//  AI Journal App
//
//  Premium glass treatment for the TabView area.
//

import SwiftUI

struct TabBarBackgroundView: View {
    let selectedIndex: Int
    @Environment(ChromeState.self) private var chrome
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                GlassStyle.tabBar()
                // Top divider line
                Rectangle()
                    .fill(AppColors.divider)
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .top)
                // Soft radial glow under selected tab
                glow(in: geo.size)
            }
        }
        .frame(height: chrome.condensedTab ? 56 : 92)
        .animation(.easeInOut(duration: 0.2), value: chrome.condensedTab)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
    
    private func glow(in size: CGSize) -> some View {
        let tabCount = 5.0
        let width = size.width / tabCount
        let x = width * (CGFloat(selectedIndex) + 0.5)
        return RadialGradient(
            colors: [AppColors.coral.opacity(0.12), .clear],
            center: .init(x: x / max(size.width, 1), y: 0.5),
            startRadius: 6,
            endRadius: 80
        )
        .blendMode(.plusLighter)
    }
}

#Preview("TabBar Background") {
    VStack { Spacer(); TabBarBackgroundView(selectedIndex: 2).environment(ChromeState()) }
}

