//
//  TopBarCapsule.swift
//  AI Journal App
//
//  Centered pill-shaped header used across tabs
//

import SwiftUI

struct TopBarCapsule: View {
    let iconSystemName: String
    let title: String
    let menu: AnyView?
    
    init(iconSystemName: String, title: String, menu: AnyView? = nil) {
        self.iconSystemName = iconSystemName
        self.title = title
        self.menu = menu
    }
    
    var body: some View {
        HStack {
            Image(system: .chevronLeft)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.inkPrimary.opacity(0.6))
            Spacer()
            HStack(spacing: AppSpacing.s) {
                Image(systemName: iconSystemName)
                    .font(.system(size: 16, weight: .semibold))
                Text(title).body(weight: .semibold)
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
            )
            .accessibilityLabel(title)
            Spacer()
            if let menu {
                Menu { menu } label: {
                    Image(system: .ellipsis)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.inkPrimary.opacity(0.6))
                }
            } else {
                Image(system: .ellipsis)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.inkPrimary.opacity(0.6))
            }
        }
    }
}

#Preview("TopBarCapsule") {
    TopBarCapsule(iconSystemName: SystemIcon.sparkles.rawValue, title: "Daily Inspiration", menu: AnyView(Button("Settings") {}))
        .padding()
        .background(GradientBackground.blushLavender)
}
