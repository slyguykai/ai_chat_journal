//
//  CircularCTA.swift
//  AI Journal App
//
//  Reusable circular call-to-action button
//

import SwiftUI

struct CircularCTA: View {
    enum Size { case small, medium, large }
    
    let icon: String
    let size: Size
    let action: () -> Void
    let accessibilityLabel: String
    let accessibilityHint: String
    
    private var dimension: CGFloat {
        switch size {
        case .small: return 56
        case .medium: return 64
        case .large: return max(64, AppRadii.large * 2.0)
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.peach, AppColors.coral],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image(system: .plusCircleFill)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: dimension, height: dimension)
        .contentShape(Circle())
        .zIndex(2)
        .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .frame(minWidth: 64, minHeight: 64)
    }
}

#Preview("CircularCTA") {
    CircularCTA(icon: "plus", size: .large, action: {}, accessibilityLabel: "Add", accessibilityHint: "Open Brain Dump")
}
