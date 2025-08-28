//
//  TactileButtonStyles.swift
//  AI Journal App
//
//  Neomorphic button styles for Tactile Calm.
//

import SwiftUI

struct TactilePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.accent)
            .clipShape(Capsule())
            .modifier(NeumorphRaised(cornerRadius: 28, distance: configuration.isPressed ? 0 : 5, blur: configuration.isPressed ? 0 : 10, highlight: AppColors.neoHighlight, shadow: AppColors.neoShadow, background: AppColors.accent))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.9), value: configuration.isPressed)
            .contentShape(Capsule())
            .frame(minHeight: 44)
    }
}

struct TactileSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.medium))
            .foregroundColor(AppColors.inkPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.background)
            .clipShape(Capsule())
            .modifier(NeumorphIndented(cornerRadius: 28, distance: configuration.isPressed ? 2 : 4, blur: 8, highlight: AppColors.neoHighlight, shadow: AppColors.neoShadow, background: AppColors.background))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.9), value: configuration.isPressed)
            .contentShape(Capsule())
            .frame(minHeight: 44)
    }
}

struct TactileIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .background(AppColors.background)
            .clipShape(Circle())
            .modifier(NeumorphIndented(cornerRadius: 22, distance: configuration.isPressed ? 2 : 4, blur: 8, highlight: AppColors.neoHighlight, shadow: AppColors.neoShadow, background: AppColors.background))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.9), value: configuration.isPressed)
            .frame(minWidth: 44, minHeight: 44)
    }
}

#Preview("Buttons") {
    VStack(spacing: 16) {
        Button("Primary") {}
            .buttonStyle(TactilePrimaryButtonStyle())
        Button("Secondary") {}
            .buttonStyle(TactileSecondaryButtonStyle())
        Button(action: {}) { Image(systemName: "heart").foregroundColor(AppColors.inkPrimary) }
            .buttonStyle(TactileIconButtonStyle())
    }
    .padding(24)
    .background(AppColors.background)
}

