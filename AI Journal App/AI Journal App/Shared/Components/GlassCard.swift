//
//  GlassCard.swift
//  AI Journal App
//
//  Reusable glassmorphism card container
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    let content: () -> Content
    
    init(cornerRadius: CGFloat = AppRadii.large, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(AppSpacing.m)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.white.opacity(0.12))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
    }
}

// MARK: - Preview

#Preview("GlassCard - Light") {
    VStack(spacing: AppSpacing.m) {
        GlassCard {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text("Title").titleM(weight: .semibold).foregroundColor(AppColors.inkPrimary)
                Text("Supporting copy goes here.").body().foregroundColor(AppColors.inkSecondary)
            }
        }
        Spacer()
    }
    .padding(AppSpacing.m)
    .background(GradientBackground.peachCream)
}

#Preview("GlassCard - Dark") {
    VStack(spacing: AppSpacing.m) {
        GlassCard {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text("Title").titleM(weight: .semibold).foregroundColor(.white)
                Text("Supporting copy goes here.").body().foregroundColor(.white.opacity(0.8))
            }
        }
        Spacer()
    }
    .padding(AppSpacing.m)
    .background(GradientBackground.blushLavender)
    .preferredColorScheme(.dark)
}
