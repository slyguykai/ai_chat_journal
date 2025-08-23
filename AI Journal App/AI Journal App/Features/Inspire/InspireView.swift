//
//  InspireView.swift
//  AI Journal App
//
//  Inspiration page with daily quotes, affirmations, and mindful moments
//

import SwiftUI

/// Inspiration content types
enum InspirationCategory: String, CaseIterable {
    case quote = "Daily Quote"
    case affirmation = "Morning Affirmation"
    case growth = "Growth Mindset"
    case mindful = "Mindful Moment"
    
    var icon: String {
        switch self {
        case .quote:
            return "sparkles"
        case .affirmation:
            return "heart.fill"
        case .growth:
            return "chart.line.uptrend.xyaxis"
        case .mindful:
            return "leaf.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .quote:
            return AppColors.apricot
        case .affirmation:
            return AppColors.peach
        case .growth:
            return AppColors.sky
        case .mindful:
            return AppColors.mint
        }
    }
}

/// Inspiration content model
struct InspirationContent {
    let id = UUID()
    let category: InspirationCategory
    let title: String
    let content: String
    let author: String?
}

/// Main inspiration view with daily content
struct InspireView: View {
    @State private var inspirationContent: [InspirationContent] = sampleInspirationContent
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                GradientBackground.blushLavender
                
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        // Header
                        VStack(spacing: AppSpacing.s) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text("Daily Inspiration")
                                    .body(weight: .semibold)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, AppSpacing.m)
                            .padding(.vertical, AppSpacing.s)
                            .background(.ultraThinMaterial)
                            .cornerRadius(AppRadii.large)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadii.large)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                            
                            Text("Find Your Spark")
                                .titleXL(weight: .bold)
                                .foregroundColor(.white)
                            
                            Text("Discover daily quotes, affirmations, and mindful moments to inspire your journey.")
                                .body()
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, AppSpacing.m)
                        
                        // Inspiration Cards
                        LazyVStack(spacing: AppSpacing.m) {
                            ForEach(inspirationContent, id: \.id) { content in
                                InspirationCard(content: content)
                            }
                        }
                        .padding(.bottom, AppSpacing.xl)
                    }
                    .padding(.horizontal, AppSpacing.m)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

/// Individual inspiration card with glass morphism style
struct InspirationCard: View {
    let content: InspirationContent
    @State private var isReflecting = false
    
    var body: some View {
        VStack(spacing: AppSpacing.m) {
            // Category header
            HStack {
                ZStack {
                    Circle()
                        .fill(content.category.iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: content.category.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(content.category.iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(content.category.rawValue)
                        .body(weight: .semibold)
                        .foregroundColor(.white)
                    
                    if !content.title.isEmpty {
                        Text(content.title)
                            .caption()
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Spacer()
            }
            
            // Main content
            VStack(spacing: AppSpacing.s) {
                if content.category == .quote {
                    // Special quote styling
                    VStack(spacing: AppSpacing.s) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.apricot)
                        
                        Text(content.content)
                            .titleM(weight: .medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        if let author = content.author {
                            Text("— \(author)")
                                .body()
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                } else {
                    // Regular content styling
                    Text(content.content)
                        .body()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // Action buttons
            HStack(spacing: AppSpacing.m) {
                Button("Reflect") {
                    Haptics.light()
                    isReflecting = true
                    // TODO: Open reflection prompt
                }
                .buttonStyle(InspirationButtonStyle(isPrimary: true))
                .accessibilityLabel("Reflect on this \(content.category.rawValue.lowercased())")
                .accessibilityHint("Opens a reflection prompt based on this content")
                
                Button("Try Later") {
                    Haptics.light()
                    // TODO: Save for later
                }
                .buttonStyle(InspirationButtonStyle(isPrimary: false))
                .accessibilityLabel("Save this \(content.category.rawValue.lowercased()) for later")
                .accessibilityHint("Saves this content to your saved items")
                
                Spacer()
            }
        }
        .padding(AppSpacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppRadii.medium)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.medium)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

/// Custom button style for inspiration actions
struct InspirationButtonStyle: ButtonStyle {
    let isPrimary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.medium))
            .foregroundColor(isPrimary ? .white : .white.opacity(0.8))
            .padding(.horizontal, AppSpacing.m)
            .padding(.vertical, AppSpacing.s)
            .background(
                RoundedRectangle(cornerRadius: AppRadii.small)
                    .fill(isPrimary ? .white.opacity(0.2) : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadii.small)
                            .stroke(.white.opacity(isPrimary ? 0.4 : 0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Sample Data

private let sampleInspirationContent: [InspirationContent] = [
    InspirationContent(
        category: .quote,
        title: "",
        content: "The only way to do great work is to love what you do.",
        author: "Steve Jobs"
    ),
    InspirationContent(
        category: .affirmation,
        title: "I am capable of amazing things today",
        content: "Today I choose to believe in my abilities and trust in my potential to achieve wonderful things.",
        author: nil
    ),
    InspirationContent(
        category: .growth,
        title: "Every challenge is an opportunity to learn",
        content: "When faced with difficulties, remember that each obstacle is a chance to grow stronger and wiser.",
        author: nil
    ),
    InspirationContent(
        category: .mindful,
        title: "Take a mindful breath",
        content: "Pause for a moment. Take three deep breaths and notice how you feel right now. This moment is yours.",
        author: nil
    )
]

// MARK: - Preview

#Preview("Inspire View - Light") {
    InspireView()
}

#Preview("Inspire View - Dark") {
    InspireView()
        .preferredColorScheme(.dark)
}

#Preview("Single Inspiration Card") {
    ZStack {
        GradientBackground.blushLavender
        
        InspirationCard(content: sampleInspirationContent[0])
            .padding(AppSpacing.m)
    }
}
