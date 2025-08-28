//
//  BrainDumpBackground.swift
//  AI Journal App
//
//  Animated "breathing" background for Brain Dump view
//

import SwiftUI

/// Subtle animated two-tone gradient that "breathes" to reduce blank-page anxiety.
struct BrainDumpBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: CGFloat = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = CGFloat(timeline.date.timeIntervalSince1970)
            let p = reduceMotion ? 0 : CGFloat(sin(t / 8.0)) // slow 16s loop (sin period 2π ≈ 16s)
            ZStack {
                LinearGradient(
                    colors: [base.lighter(by: 0.02 + 0.01 * p), base.darker(by: 0.02 - 0.01 * p)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .opacity(0.9)
                
                RadialGradient(
                    colors: [base.lighter(by: 0.04).opacity(0.6 + 0.1 * p), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 800
                )
                .ignoresSafeArea()
            }
        }
    }
    
    private var base: Color { AppColors.background }
}

// MARK: - Preview

#Preview("Brain Dump Background - Light") {
    BrainDumpBackground()
}
