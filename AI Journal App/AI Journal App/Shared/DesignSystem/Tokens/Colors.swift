//
//  Colors.swift
//  AI Journal App
//
//  Design System Color Tokens
//

import SwiftUI

/// Semantic color tokens for the AI Journal App design system
struct AppColors {
    
    // MARK: - Ink (Text Colors)
    
    /// Primary text color - highest contrast
    static let inkPrimary = Color(hex: "0F1115")
    
    /// Secondary text color - 70% opacity for reduced emphasis
    static let inkSecondary = Color(hex: "2C2F36").opacity(0.7)
    
    // MARK: - Surface Colors
    
    /// Main canvas background color
    static let canvas = Color(hex: "FFF8F3")
    
    /// Surface background for cards and containers
    static let surface = Color(hex: "FFFFFF")
    
    /// Divider and border color
    static let divider = Color(hex: "E9E9EE")
    
    // MARK: - Accent Colors
    
    /// Warm peach accent
    static let peach = Color(hex: "FFB98A")
    
    /// Coral accent for primary actions
    static let coral = Color(hex: "FF8A65")
    
    /// Soft apricot for subtle highlights
    static let apricot = Color(hex: "FFD3A1")
    
    /// Blush pink for mood indicators
    static let blush = Color(hex: "F7C4CF")
    
    /// Lavender for calm states
    static let lavender = Color(hex: "CBB7FF")
    
    /// Sky blue for positive moods
    static let sky = Color(hex: "BFEAF5")
    
    /// Mint green for success states
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


