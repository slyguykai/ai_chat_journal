//
//  ButtonStyles.swift
//  AI Journal App
//
//  Shared button styles used across the app
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .background(AppColors.coral)
            .cornerRadius(AppRadii.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.medium))
            .foregroundColor(AppColors.inkPrimary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .background(AppColors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadii.medium)
                    .stroke(AppColors.divider, lineWidth: 1)
            )
            .cornerRadius(AppRadii.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
