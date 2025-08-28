//
//  Colors.swift
//  AI Journal App
//
//  Design System Color Tokens
//

import SwiftUI

/// Semantic color tokens for the AI Journal App design system
struct AppColors {
    
    // MARK: - Tactile Calm Core Palette
    
    /// Base background “material” color
    static let background = Color(hex: "F0F2F5")
    
    /// Primary text color (desaturated slate blue)
    static let inkPrimary = Color(hex: "3D4A5C")
    
    /// Secondary text color (reduced emphasis)
    static let inkSecondary = Color(hex: "3D4A5C").opacity(0.7)
    
    /// Accent teal used sparingly for primary CTAs and active states
    static let accent = Color(hex: "22C5C5")
    
    /// Neomorphic highlight (top/left) and shadow (bottom/right)
    static let neoHighlight = Color(hex: "FFFFFF")
    static let neoShadow = Color(hex: "D9DCE1")
    
    // MARK: - Legacy/Compatibility Tokens
    // These map to the new palette to reduce churn while migrating screens.
    static let canvas = AppColors.background
    static let surface = AppColors.background
    static let divider = AppColors.neoShadow
    
    // Legacy accents retained for gradual UI transition; avoid for new work
    static let peach = Color(hex: "FFB98A")
    static let coral = Color(hex: "FF8A65")
    static let apricot = Color(hex: "FFD3A1")
    static let blush = Color(hex: "F7C4CF")
    static let lavender = Color(hex: "CBB7FF")
    static let sky = Color(hex: "BFEAF5")
    static let mint = Color(hex: "CFEAD6")
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func lighter(by amount: CGFloat) -> Color {
        Color(UIColor(self).lighter(by: amount))
    }
    func darker(by amount: CGFloat) -> Color {
        Color(UIColor(self).darker(by: amount))
    }
}

private extension UIColor {
    func lighter(by amount: CGFloat) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return self }
        return UIColor(red: min(r + amount, 1), green: min(g + amount, 1), blue: min(b + amount, 1), alpha: a)
    }
    func darker(by amount: CGFloat) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return self }
        return UIColor(red: max(r - amount, 0), green: max(g - amount, 0), blue: max(b - amount, 0), alpha: a)
    }
}

// MARK: - Preview

#Preview("Color Tokens - Light") {
    VStack(spacing: 12) {
        Group {
            ColorRow(name: "Ink Primary", color: AppColors.inkPrimary)
            ColorRow(name: "Ink Secondary", color: AppColors.inkSecondary)
            ColorRow(name: "Canvas", color: AppColors.canvas)
            ColorRow(name: "Surface", color: AppColors.surface)
            ColorRow(name: "Divider", color: AppColors.divider)
        }
        
        Group {
            ColorRow(name: "Peach", color: AppColors.peach)
            ColorRow(name: "Coral", color: AppColors.coral)
            ColorRow(name: "Apricot", color: AppColors.apricot)
            ColorRow(name: "Blush", color: AppColors.blush)
            ColorRow(name: "Lavender", color: AppColors.lavender)
            ColorRow(name: "Sky", color: AppColors.sky)
            ColorRow(name: "Mint", color: AppColors.mint)
        }
    }
    .padding(16)
    .background(AppColors.canvas)
}

#Preview("Color Tokens - Dark") {
    VStack(spacing: 12) {
        Group {
            ColorRow(name: "Ink Primary", color: AppColors.inkPrimary)
            ColorRow(name: "Ink Secondary", color: AppColors.inkSecondary)
            ColorRow(name: "Canvas", color: AppColors.canvas)
            ColorRow(name: "Surface", color: AppColors.surface)
            ColorRow(name: "Divider", color: AppColors.divider)
        }
        
        Group {
            ColorRow(name: "Peach", color: AppColors.peach)
            ColorRow(name: "Coral", color: AppColors.coral)
            ColorRow(name: "Apricot", color: AppColors.apricot)
            ColorRow(name: "Blush", color: AppColors.blush)
            ColorRow(name: "Lavender", color: AppColors.lavender)
            ColorRow(name: "Sky", color: AppColors.sky)
            ColorRow(name: "Mint", color: AppColors.mint)
        }
    }
    .padding(16)
    .background(Color.black)
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helper

private struct ColorRow: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(width: 40, height: 40)
            
            Text(name)
                .foregroundColor(AppColors.inkPrimary)
            
            Spacer()
        }
    }
}
