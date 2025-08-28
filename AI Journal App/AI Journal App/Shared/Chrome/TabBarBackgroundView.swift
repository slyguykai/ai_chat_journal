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
                // Neomorphic tab bar surface
                Rectangle()
                    .fill(AppColors.background)
                    .shadow(color: AppColors.neoHighlight.opacity(0.8), radius: 8, x: 0, y: -1)
                    .shadow(color: AppColors.neoShadow.opacity(0.9), radius: 12, x: 0, y: 6)
                // Top subtle divider
                Rectangle()
                    .fill(AppColors.neoShadow.opacity(0.6))
                    .frame(height: 0.5)
                    .frame(maxHeight: .infinity, alignment: .top)
                // Optional soft accent glow under selected tab (very subtle)
                glow(in: geo.size)
                    .opacity(0.15)
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
            colors: [AppColors.accent.opacity(0.2), .clear],
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
