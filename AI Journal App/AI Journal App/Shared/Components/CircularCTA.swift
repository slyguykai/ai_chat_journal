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
    let backgroundColor: Color
    let action: () -> Void
    let accessibilityLabel: String
    let accessibilityHint: String

    init(icon: String, size: Size, action: @escaping () -> Void, accessibilityLabel: String, accessibilityHint: String, backgroundColor: Color = .black) {
        self.icon = icon
        self.size = size
        self.backgroundColor = backgroundColor
        self.action = action
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
    }
    
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
                    .fill(backgroundColor)
                    .overlay(
                        Circle()
                            .stroke(AppColors.neoHighlight.opacity(0.6), lineWidth: 1)
                            .blur(radius: 1.5)
                            .offset(x: -1, y: -1)
                            .mask(
                                Circle().fill(
                                    LinearGradient(colors: [.white, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            )
                    )
                    .modifier(NeumorphRaised(cornerRadius: dimension / 2, distance: 5, blur: 10, highlight: AppColors.neoHighlight, shadow: AppColors.neoShadow, background: backgroundColor))
                Image(systemName: icon)
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
    CircularCTA(icon: "plus", size: .large, action: {}, accessibilityLabel: "Add", accessibilityHint: "Open Brain Dump", backgroundColor: .black)
}
