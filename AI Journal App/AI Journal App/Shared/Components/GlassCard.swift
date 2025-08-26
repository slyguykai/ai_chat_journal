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
    
    init(cornerRadius: CGFloat = AppRadii.medium, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(AppSpacing.m)
            .glassCard(cornerRadius: cornerRadius)
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
    .pastelBackground(.peachCream)
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
    .pastelBackground(.blushLavender)
    .preferredColorScheme(.dark)
}
