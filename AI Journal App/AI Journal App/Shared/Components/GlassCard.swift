//
//  GlassCard.swift
//  AI Journal App
//
//  Reusable glassmorphism card container
//

import SwiftUI

struct GlassCard<Content: View>: View {
    // Backward-compatible wrapper around SurfaceCard for migration
    let cornerRadius: CGFloat
    let content: () -> Content
    
    init(cornerRadius: CGFloat = AppRadii.medium, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        SurfaceCard(cornerRadius: cornerRadius) { content() }
    }
}

// MARK: - Preview

#Preview("GlassCard - Light") {
    VStack(spacing: AppSpacing.m) {
        SurfaceCard {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text("Title").titleM(weight: .semibold).foregroundColor(AppColors.inkPrimary)
                Text("Supporting copy goes here.").body().foregroundColor(AppColors.inkSecondary)
            }
        }
        Spacer()
    }
    .padding(AppSpacing.m)
    .pastelBackground(.peachCream)
}

#Preview("GlassCard - Dark") {
    VStack(spacing: AppSpacing.m) {
        SurfaceCard {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text("Title").titleM(weight: .semibold).foregroundColor(.white)
                Text("Supporting copy goes here.").body().foregroundColor(.white.opacity(0.8))
            }
        }
        Spacer()
    }
    .padding(AppSpacing.m)
    .pastelBackground(.blushLavender)
    .preferredColorScheme(.dark)
}
