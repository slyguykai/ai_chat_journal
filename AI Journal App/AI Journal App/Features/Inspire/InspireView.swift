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
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .top) {
            // Premium layered background
            GradientBackground.blushLavender
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.15), Color.clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .overlay(
                    RadialGradient(
                        colors: [Color.white.opacity(0.12), Color.clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 380
                    )
                )
                .ignoresSafeArea(.container, edges: [.top, .bottom])
            
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    TopBarCapsule(iconSystemName: "sparkles", title: "Daily Inspiration")
                    
                    // Title and subtitle block
                    VStack(alignment: .leading, spacing: AppSpacing.s) {
                        Text("Find Your Spark")
                            .titleXL(weight: .bold)
                            .foregroundColor(AppColors.inkPrimary)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.0), radius: 1, x: 0, y: 1)
                        
                        Text("Discover daily quotes, affirmations, and mindful moments to inspire your journey.")
                            .body()
                            .foregroundColor(AppColors.inkSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Quote hero card (gradient tile)
                    QuoteHeroCard(content: inspirationContent.first { $0.category == .quote }!)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Daily quote: \(inspirationContent.first { $0.category == .quote }?.content ?? "")")
                        
                    // List tiles with translucent glass style
                    LazyVStack(spacing: AppSpacing.m) {
                        ForEach(inspirationContent.filter { $0.category != .quote }, id: \.id) { content in
                            GlassCard(cornerRadius: AppRadii.large) {
                                TileRow(content: content)
                            }
                        }
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .bottom) { Spacer().frame(height: AppSpacing.l) }
        }
    }
}

// MARK: - Quote Hero Card

private struct QuoteHeroCard: View {
    let content: InspirationContent
    
    var body: some View {
        VStack(spacing: AppSpacing.s) {
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(AppColors.coral)
            
            Text(content.content)
                .titleM(weight: .medium)
                .foregroundColor(AppColors.inkPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            if let author = content.author {
                Text("— \(author)")
                    .body()
                    .foregroundColor(AppColors.inkSecondary)
            }
        }
        .padding(AppSpacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppRadii.large)
                .fill(
                    LinearGradient(
                        colors: [AppColors.blush.opacity(0.9), AppColors.lavender.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 12)
        )
    }
}

// MARK: - Tile Row

private struct TileRow: View {
    let content: InspirationContent
    
    var body: some View {
        HStack(spacing: AppSpacing.m) {
            ZStack {
                Circle()
                    .fill(content.category.iconColor.opacity(0.25))
                    .frame(width: 44, height: 44)
                Image(systemName: content.category.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(content.category.iconColor)
            }
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(content.category.rawValue)
                    .titleL(weight: .semibold)
                    .foregroundColor(AppColors.inkPrimary)
                if !content.title.isEmpty {
                    Text(content.title)
                        .body()
                        .foregroundColor(AppColors.inkSecondary)
                        .lineLimit(2)
                }
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(content.category.rawValue). \(content.title)")
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
        QuoteHeroCard(content: sampleInspirationContent[0])
            .padding(AppSpacing.m)
    }
}
