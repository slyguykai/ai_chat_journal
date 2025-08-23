//
//  GradientBackground.swift
//  AI Journal App
//
//  Design System Gradient Backgrounds
//

import SwiftUI

/// Predefined gradient backgrounds for the app
struct GradientBackground: View {
    let preset: GradientPreset
    var body: some View {
        preset.gradient
            .ignoresSafeArea()
    }
}

/// Available gradient presets
enum GradientPreset {
    case sunrise
    case blushLavender
    case peachCream
    
    /// Linear gradient for the preset
    var gradient: LinearGradient {
        switch self {
        case .sunrise:
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "FFE0B2"), location: 0.0),
                    .init(color: Color(hex: "FFB07B"), location: 0.5),
                    .init(color: Color(hex: "FF8A65"), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .blushLavender:
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "FAD4E6"), location: 0.0),
                    .init(color: Color(hex: "E6D2FF"), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .peachCream:
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "FFEAD6"), location: 0.0),
                    .init(color: Color(hex: "FFD3A1"), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Display name for the preset
    var name: String {
        switch self {
        case .sunrise: return "Sunrise"
        case .blushLavender: return "Blush Lavender"
        case .peachCream: return "Peach Cream"
        }
    }
    
    /// Description of the gradient
    var description: String {
        switch self {
        case .sunrise: return "Warm orange to coral gradient"
        case .blushLavender: return "Soft pink to lavender gradient"
        case .peachCream: return "Peach to apricot gradient"
        }
    }
}

// MARK: - Convenience Initializers

extension GradientBackground {
    static var sunrise: GradientBackground { GradientBackground(preset: .sunrise) }
    static var blushLavender: GradientBackground { GradientBackground(preset: .blushLavender) }
    static var peachCream: GradientBackground { GradientBackground(preset: .peachCream) }
}

// MARK: - Preview

#Preview("Gradient Backgrounds - Light") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Gradient Presets")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.top, 16)
            VStack(spacing: 16) {
                GradientPreviewCard(preset: .sunrise)
                GradientPreviewCard(preset: .blushLavender)
                GradientPreviewCard(preset: .peachCream)
            }
        }
        .padding(16)
    }
    .background(Color(red: 1.0, green: 0.97, blue: 0.95))
}

#Preview("Gradient Backgrounds - Dark") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Gradient Presets")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 16)
            VStack(spacing: 16) {
                GradientPreviewCard(preset: .sunrise, isDark: true)
                GradientPreviewCard(preset: .blushLavender, isDark: true)
                GradientPreviewCard(preset: .peachCream, isDark: true)
            }
        }
        .padding(16)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helper

private struct GradientPreviewCard: View {
    let preset: GradientPreset
    var isDark: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(preset.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(isDark ? .white : .primary)
                    Text(preset.description)
                        .font(.caption)
                        .foregroundColor(isDark ? .white.opacity(0.7) : .secondary)
                }
                Spacer()
                RoundedRectangle(cornerRadius: 12)
                    .fill(preset.gradient)
                    .frame(width: 60, height: 40)
            }
        }
        .padding(16)
        .background(isDark ? Color.gray.opacity(0.1) : .white)
        .cornerRadius(16)
    }
}


