//
//  NeumorphicModifier.swift
//  AI Journal App
//
//  Reusable neomorphic effects for Tactile Calm: raised (extruded) and indented (concave).
//

import SwiftUI

struct NeumorphRaised: ViewModifier {
    let cornerRadius: CGFloat
    let distance: CGFloat
    let blur: CGFloat
    let highlight: Color
    let shadow: Color
    let background: Color
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: highlight.opacity(0.8), radius: blur * 0.6, x: -distance, y: -distance)
            .shadow(color: shadow.opacity(0.8), radius: blur, x: distance, y: distance)
    }
}

struct NeumorphIndented: ViewModifier {
    let cornerRadius: CGFloat
    let distance: CGFloat
    let blur: CGFloat
    let highlight: Color
    let shadow: Color
    let background: Color
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            // Top-left inner shadow
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(shadow.opacity(0.9), lineWidth: 1)
                    .blur(radius: blur)
                    .offset(x: -distance, y: -distance)
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(colors: [.black, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    )
            )
            // Bottom-right inner highlight
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(highlight.opacity(0.9), lineWidth: 1)
                    .blur(radius: blur)
                    .offset(x: distance, y: distance)
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(colors: [.clear, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    )
            )
    }
}

extension View {
    func neumorphRaised(
        cornerRadius: CGFloat = AppRadii.medium,
        distance: CGFloat = 6,
        blur: CGFloat = 12,
        highlight: Color = AppColors.neoHighlight,
        shadow: Color = AppColors.neoShadow,
        background: Color = AppColors.background
    ) -> some View {
        modifier(NeumorphRaised(cornerRadius: cornerRadius, distance: distance, blur: blur, highlight: highlight, shadow: shadow, background: background))
    }
    
    func neumorphIndented(
        cornerRadius: CGFloat = AppRadii.medium,
        distance: CGFloat = 4,
        blur: CGFloat = 8,
        highlight: Color = AppColors.neoHighlight,
        shadow: Color = AppColors.neoShadow,
        background: Color = AppColors.background
    ) -> some View {
        modifier(NeumorphIndented(cornerRadius: cornerRadius, distance: distance, blur: blur, highlight: highlight, shadow: shadow, background: background))
    }
}

#Preview("Neumorphic Samples") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Tactile Calm Neomorphism")
                .font(.headline)
                .foregroundColor(AppColors.inkPrimary)
            
            HStack(spacing: 16) {
                VStack(spacing: 12) {
                    Text("Raised Card").caption().foregroundColor(AppColors.inkSecondary)
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .fill(AppColors.background)
                        .frame(width: 140, height: 90)
                        .neumorphRaised(cornerRadius: AppRadii.large)
                }
                VStack(spacing: 12) {
                    Text("Indented Field").caption().foregroundColor(AppColors.inkSecondary)
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .fill(AppColors.background)
                        .frame(width: 140, height: 90)
                        .neumorphIndented(cornerRadius: AppRadii.large)
                }
            }
            
            Button("Primary CTA") {}
                .font(AppTypography.body.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(AppColors.accent)
                .clipShape(Capsule())
                .neumorphRaised(cornerRadius: 28, distance: 5, blur: 10, highlight: .white.opacity(0.9), shadow: AppColors.neoShadow)
        }
        .padding(24)
        .background(AppColors.background)
    }
}

