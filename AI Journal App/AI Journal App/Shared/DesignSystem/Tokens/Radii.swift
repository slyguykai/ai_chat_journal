//
//  Radii.swift
//  AI Journal App
//
//  Design System Border Radius Tokens
//

import SwiftUI

/// Border radius tokens for consistent corner treatments
struct AppRadii {
    
    /// Large radius: 24pt - for main cards and containers
    static let large: CGFloat = 24
    
    /// Medium radius: 16pt - for buttons and smaller cards
    static let medium: CGFloat = 16
    
    /// Small radius: 12pt - for inputs and small elements
    static let small: CGFloat = 12
}

// MARK: - Preview

#Preview("Border Radius - Light") {
    VStack(spacing: 24) {
        Text("Border Radius Scale")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
        
        VStack(spacing: 16) {
            RadiusCard(
                title: "Large (24pt)",
                subtitle: "Main cards, containers",
                radius: AppRadii.large,
                color: .orange
            )
            
            RadiusCard(
                title: "Medium (16pt)",
                subtitle: "Buttons, smaller cards",
                radius: AppRadii.medium,
                color: .pink
            )
            
            RadiusCard(
                title: "Small (12pt)",
                subtitle: "Inputs, small elements",
                radius: AppRadii.small,
                color: .mint
            )
        }
        
        Text("Usage Examples")
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.top, 24)
        
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: AppRadii.large)
                .fill(.pink.opacity(0.3))
                .frame(width: 80, height: 60)
                .overlay(
                    Text("Card")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                )
            
            RoundedRectangle(cornerRadius: AppRadii.medium)
                .fill(.purple.opacity(0.3))
                .frame(width: 60, height: 40)
                .overlay(
                    Text("Button")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                )
            
            RoundedRectangle(cornerRadius: AppRadii.small)
                .fill(.mint.opacity(0.3))
                .frame(width: 40, height: 30)
                .overlay(
                    Text("Input")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                )
        }
    }
    .padding(16)
    .background(Color(red: 1.0, green: 0.97, blue: 0.95))
}

#Preview("Border Radius - Dark") {
    VStack(spacing: 24) {
        Text("Border Radius Scale")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        
        VStack(spacing: 16) {
            RadiusCard(
                title: "Large (24pt)",
                subtitle: "Main cards, containers",
                radius: AppRadii.large,
                color: .orange,
                isDark: true
            )
            
            RadiusCard(
                title: "Medium (16pt)",
                subtitle: "Buttons, smaller cards",
                radius: AppRadii.medium,
                color: .pink,
                isDark: true
            )
            
            RadiusCard(
                title: "Small (12pt)",
                subtitle: "Inputs, small elements",
                radius: AppRadii.small,
                color: .mint,
                isDark: true
            )
        }
        
        Text("Usage Examples")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 24)
        
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: AppRadii.large)
                .fill(.pink.opacity(0.3))
                .frame(width: 80, height: 60)
                .overlay(
                    Text("Card")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: AppRadii.medium)
                .fill(.purple.opacity(0.3))
                .frame(width: 60, height: 40)
                .overlay(
                    Text("Button")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: AppRadii.small)
                .fill(.mint.opacity(0.3))
                .frame(width: 40, height: 30)
                .overlay(
                    Text("Input")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                )
        }
    }
    .padding(16)
    .background(Color.black)
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helper

private struct RadiusCard: View {
    let title: String
    let subtitle: String
    let radius: CGFloat
    let color: Color
    var isDark: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: radius)
                .fill(color)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(isDark ? .white : .primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(isDark ? .white.opacity(0.7) : .secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(isDark ? Color.gray.opacity(0.1) : .white)
        .cornerRadius(AppRadii.medium)
    }
}


