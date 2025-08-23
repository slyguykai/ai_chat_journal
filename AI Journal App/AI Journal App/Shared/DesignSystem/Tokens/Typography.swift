//
//  Typography.swift
//  AI Journal App
//
//  Design System Typography Tokens
//

import SwiftUI

/// Typography system using SF Pro with Dynamic Type support
struct AppTypography {
    
    // MARK: - Title Styles
    
    /// Extra large title (SF Pro Display, 34pt)
    static let titleXL = Font.custom("SF Pro Display", size: 34, relativeTo: .largeTitle)
    
    /// Large title (SF Pro Display, 28pt)
    static let titleL = Font.custom("SF Pro Display", size: 28, relativeTo: .title)
    
    /// Medium title (SF Pro Display, 22pt)
    static let titleM = Font.custom("SF Pro Display", size: 22, relativeTo: .title2)
    
    // MARK: - Body Styles
    
    /// Body text (SF Pro Text, 17pt)
    static let body = Font.custom("SF Pro Text", size: 17, relativeTo: .body)
    
    /// Caption text (SF Pro Text, 12pt)
    static let caption = Font.custom("SF Pro Text", size: 12, relativeTo: .caption)
    
    // MARK: - Font Weights
    
    struct Weight {
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
    }
}

// MARK: - Text Style Extensions

extension Text {
    func titleXL(weight: Font.Weight = .bold) -> some View {
        self.font(AppTypography.titleXL.weight(weight))
    }
    
    func titleL(weight: Font.Weight = .semibold) -> some View {
        self.font(AppTypography.titleL.weight(weight))
    }
    
    func titleM(weight: Font.Weight = .semibold) -> some View {
        self.font(AppTypography.titleM.weight(weight))
    }
    
    func body(weight: Font.Weight = .regular) -> some View {
        self.font(AppTypography.body.weight(weight))
    }
    
    func caption(weight: Font.Weight = .regular) -> some View {
        self.font(AppTypography.caption.weight(weight))
    }
}

// MARK: - Preview

#Preview("Typography - Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Typography Scale")
                    .titleL()
                    .foregroundColor(.primary)
                
                Text("Dynamic Type enabled for accessibility")
                    .caption()
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                TypographyRow(
                    title: "Title XL",
                    sample: "New Day Fresh Start!",
                    style: .titleXL
                )
                
                TypographyRow(
                    title: "Title L",
                    sample: "Good Evening",
                    style: .titleL
                )
                
                TypographyRow(
                    title: "Title M",
                    sample: "Morning Reflection",
                    style: .titleM
                )
                
                TypographyRow(
                    title: "Body",
                    sample: "Are you the type of person who leaves reviews often?",
                    style: .body
                )
                
                TypographyRow(
                    title: "Caption",
                    sample: "5 DAY STREAK",
                    style: .caption
                )
            }
        }
        .padding(16)
    }
    .background(Color(red: 1.0, green: 0.97, blue: 0.95))
}

#Preview("Typography - Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Typography Scale")
                    .titleL()
                    .foregroundColor(.white)
                
                Text("Dynamic Type enabled for accessibility")
                    .caption()
                    .foregroundColor(.white.opacity(0.7))
            }
            
            VStack(alignment: .leading, spacing: 16) {
                TypographyRow(
                    title: "Title XL",
                    sample: "New Day Fresh Start!",
                    style: .titleXL,
                    isDark: true
                )
                
                TypographyRow(
                    title: "Title L",
                    sample: "Good Evening",
                    style: .titleL,
                    isDark: true
                )
                
                TypographyRow(
                    title: "Title M",
                    sample: "Morning Reflection",
                    style: .titleM,
                    isDark: true
                )
                
                TypographyRow(
                    title: "Body",
                    sample: "Are you the type of person who leaves reviews often?",
                    style: .body,
                    isDark: true
                )
                
                TypographyRow(
                    title: "Caption",
                    sample: "5 DAY STREAK",
                    style: .caption,
                    isDark: true
                )
            }
        }
        .padding(16)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helper

private enum TypographyStyle {
    case titleXL, titleL, titleM, body, caption
}

private struct TypographyRow: View {
    let title: String
    let sample: String
    let style: TypographyStyle
    var isDark: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .caption(weight: .medium)
                .foregroundColor(isDark ? .white.opacity(0.7) : .secondary)
            
            Group {
                switch style {
                case .titleXL:
                    Text(sample).titleXL()
                case .titleL:
                    Text(sample).titleL()
                case .titleM:
                    Text(sample).titleM()
                case .body:
                    Text(sample).body()
                case .caption:
                    Text(sample).caption()
                }
            }
            .foregroundColor(isDark ? .white : .primary)
        }
    }
}


