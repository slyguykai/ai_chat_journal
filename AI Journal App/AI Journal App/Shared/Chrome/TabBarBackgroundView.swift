//
//  TabBarBackgroundView.swift
//  AI Journal App
//
//  Premium glass treatment for the TabView area.
//

import SwiftUI

struct TabBarBackgroundView: View {
    let selectedIndex: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // Ultra-thin material tinted by canvas
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .background(AppColors.canvas.opacity(0.85))
                    .ignoresSafeArea()
                
                // Top divider line
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(AppColors.divider)
                        .frame(height: 1)
                    Spacer()
                }
                
                // Soft radial glow under selected tab
                glow(in: geo.size)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
    
    private func glow(in size: CGSize) -> some View {
        let tabCount = 5.0
        let width = size.width / tabCount
        let x = width * (CGFloat(selectedIndex) + 0.5)
        return RadialGradient(
            colors: [AppColors.coral.opacity(0.12), .clear],
            center: .init(x: x / max(size.width, 1), y: 0.35),
            startRadius: 6,
            endRadius: 80
        )
        .blendMode(.plusLighter)
        .ignoresSafeArea()
    }
}

#Preview("TabBar Background") {
    VStack {
        Spacer()
        TabBarBackgroundView(selectedIndex: 2)
            .frame(height: 100)
    }
}
