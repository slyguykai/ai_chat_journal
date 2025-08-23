//
//  TopBarCapsule.swift
//  AI Journal App
//
//  Reusable top bar with centered capsule title, matching Library proportions
//

import SwiftUI

struct TopBarCapsule: View {
    let iconSystemName: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.inkPrimary.opacity(0.6))
            Spacer()
            HStack(spacing: AppSpacing.s) {
                Image(systemName: iconSystemName)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .body(weight: .semibold)
            }
            .foregroundColor(AppColors.inkPrimary)
            .padding(.horizontal, AppSpacing.l)
            .padding(.vertical, AppSpacing.s)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .accessibilityLabel(title)
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.inkPrimary.opacity(0.6))
        }
    }
}

#Preview("TopBarCapsule") {
    ZStack { GradientBackground.blushLavender }
        .overlay(
            TopBarCapsule(iconSystemName: "book", title: "My Library")
                .padding()
        , alignment: .top)
}
