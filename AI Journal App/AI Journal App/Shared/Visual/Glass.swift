//
//  Glass.swift
//  AI Journal App
//
//  Reusable glass styles for cards, toolbars and tab bars
//

import SwiftUI

struct GlassStyle {
    static func card(cornerRadius: CGFloat = AppRadii.medium) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.30), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
    
    static func toolbar(cornerRadius: CGFloat = AppRadii.medium) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.30), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
    }
    
    static func tabBar() -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay(Rectangle().fill(Color.white.opacity(0.12)))
            .overlay(Rectangle().stroke(Color.white.opacity(0.30), lineWidth: 0.5))
            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: -2)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = AppRadii.medium) -> some View {
        background(GlassStyle.card(cornerRadius: cornerRadius))
    }
    func glassToolbar(cornerRadius: CGFloat = AppRadii.medium) -> some View {
        background(GlassStyle.toolbar(cornerRadius: cornerRadius))
    }
    func glassTabBar() -> some View {
        background(GlassStyle.tabBar())
    }
}
