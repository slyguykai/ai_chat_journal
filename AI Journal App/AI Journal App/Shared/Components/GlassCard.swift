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
            .background(
                ZStack {
                    // Material base with blur
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .blur(radius: 20)
                    // Subtle inner highlight for premium sheen
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(0.10))
                        .blendMode(.screen)
                    // Crisp stroke for definition
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                // Dual shadow: soft ambient + contact for depth
                .shadow(color: Color.black.opacity(0.10), radius: 20, x: 0, y: 12)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
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
