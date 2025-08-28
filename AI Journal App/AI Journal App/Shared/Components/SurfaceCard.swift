//
//  SurfaceCard.swift
//  AI Journal App
//
//  Neomorphic raised card wrapper for Tactile Calm.
//

import SwiftUI

struct SurfaceCard<Content: View>: View {
    let cornerRadius: CGFloat
    let content: () -> Content
    
    init(cornerRadius: CGFloat = AppRadii.large, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(AppSpacing.m)
            .background(AppColors.background)
            .neumorphRaised(cornerRadius: cornerRadius)
    }
}

#Preview("SurfaceCard") {
    VStack(spacing: 16) {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Title").titleM(weight: .semibold).foregroundColor(AppColors.inkPrimary)
                Text("Supporting copy goes here.").body().foregroundColor(AppColors.inkSecondary)
            }
        }
    }
    .padding(24)
    .background(AppColors.background)
}

