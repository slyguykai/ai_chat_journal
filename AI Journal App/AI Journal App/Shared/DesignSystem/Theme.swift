//
//  Theme.swift
//  AI Journal App
//
//  Design System Theme Management
//

import SwiftUI

/// App theme containing light and dark mode palettes
struct AppTheme {
    let light: ColorPalette
    let dark: ColorPalette
    
    /// Current palette based on color scheme
    func palette(for colorScheme: ColorScheme) -> ColorPalette {
        switch colorScheme {
        case .dark:
            return dark
        case .light:
            return light
        @unknown default:
            return light
        }
    }
}

/// Color palette for a specific theme mode
struct ColorPalette {
    // Text colors
    let inkPrimary: Color
    let inkSecondary: Color
    
    // Surface colors
    let canvas: Color
    let surface: Color
    let divider: Color
    
    // Accent colors (remain consistent across themes)
    let peach: Color
    let coral: Color
    let apricot: Color
    let blush: Color
    let lavender: Color
    let sky: Color
    let mint: Color
}

// MARK: - Default Theme

extension AppTheme {
    static let `default` = AppTheme(
        light: ColorPalette(
            inkPrimary: AppColors.inkPrimary,
            inkSecondary: AppColors.inkSecondary,
            canvas: AppColors.canvas,
            surface: AppColors.surface,
            divider: AppColors.divider,
            peach: AppColors.peach,
            coral: AppColors.coral,
            apricot: AppColors.apricot,
            blush: AppColors.blush,
            lavender: AppColors.lavender,
            sky: AppColors.sky,
            mint: AppColors.mint
        ),
        dark: ColorPalette(
            inkPrimary: .white,
            inkSecondary: .white.opacity(0.7),
            canvas: Color(hex: "0F1115"),
            surface: Color(hex: "1C1C1E"),
            divider: Color(hex: "38383A"),
            peach: AppColors.peach,
            coral: AppColors.coral,
            apricot: AppColors.apricot,
            blush: AppColors.blush,
            lavender: AppColors.lavender,
            sky: AppColors.sky,
            mint: AppColors.mint
        )
    )
}

// MARK: - Environment Key

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.default
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    /// Apply the app theme to the environment
    func appTheme(_ theme: AppTheme = .default) -> some View {
        environment(\.appTheme, theme)
    }
}

// MARK: - Theme-Aware Color Access

extension View {
    /// Get the current color palette from environment
    @ViewBuilder
    func themePalette<Content: View>(@ViewBuilder content: @escaping (ColorPalette) -> Content) -> some View {
        GeometryReader { _ in
            content(AppTheme.default.light) // Fallback for preview
        }
        .environment(\.colorScheme, .light)
        .overlay(
            GeometryReader { _ in
                EmptyView()
            }
            .environment(\.colorScheme, .dark)
            .opacity(0)
        )
    }
}

// MARK: - Preview

#Preview("Theme System - Light") {
    VStack(spacing: 24) {
        Text("Light Theme")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(AppTheme.default.light.inkPrimary)
        
        ThemePreviewGrid(palette: AppTheme.default.light)
    }
    .padding(16)
    .background(AppTheme.default.light.canvas)
}

#Preview("Theme System - Dark") {
    VStack(spacing: 24) {
        Text("Dark Theme")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(AppTheme.default.dark.inkPrimary)
        
        ThemePreviewGrid(palette: AppTheme.default.dark)
    }
    .padding(16)
    .background(AppTheme.default.dark.canvas)
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helper

private struct ThemePreviewGrid: View {
    let palette: ColorPalette
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
            ThemeColorCard(name: "Ink Primary", color: palette.inkPrimary)
            ThemeColorCard(name: "Ink Secondary", color: palette.inkSecondary)
            ThemeColorCard(name: "Canvas", color: palette.canvas)
            ThemeColorCard(name: "Surface", color: palette.surface)
            ThemeColorCard(name: "Divider", color: palette.divider)
            ThemeColorCard(name: "Coral", color: palette.coral)
            ThemeColorCard(name: "Peach", color: palette.peach)
            ThemeColorCard(name: "Lavender", color: palette.lavender)
        }
    }
}

private struct ThemeColorCard: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(height: 40)
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}


