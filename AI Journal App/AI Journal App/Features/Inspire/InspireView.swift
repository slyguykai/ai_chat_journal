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
            return SystemIcon.sparkles.rawValue
        case .affirmation:
            return SystemIcon.heartFill.rawValue
        case .growth:
            return SystemIcon.chartLineUptrendXYAxis.rawValue
        case .mindful:
            return SystemIcon.leafFill.rawValue
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
    @State private var showSettings = false
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    TopBarCapsule(
                        iconSystemName: SystemIcon.sparkles.rawValue,
                        title: "Daily Inspiration",
                        menu: AnyView(
                            Group {
                                Button("Settings") { showSettings = true }
                                Button("About") {}
                            }
                        )
                    )
                    
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
                    
                    // Quote hero card
                    QuoteHeroCard(content: inspirationContent.first { $0.category == .quote }!)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Daily quote: \(inspirationContent.first { $0.category == .quote }?.content ?? "")")
                        
                    // List tiles
                    LazyVStack(spacing: AppSpacing.m) {
                        ForEach(inspirationContent.filter { $0.category != .quote }, id: \.id) { content in
                            SurfaceCard(cornerRadius: AppRadii.large) { TileRow(content: content) }
                                .cardPress()
                        }
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
                .contentShape(Rectangle())
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
        }
        .appTheme()
        .sheet(isPresented: $showSettings) { NavigationStack { SettingsView() } }
    }
}

// MARK: - Quote Hero Card

private struct QuoteHeroCard: View {
    let content: InspirationContent
    
    var body: some View {
        SurfaceCard(cornerRadius: AppRadii.large) {
            VStack(spacing: AppSpacing.s) {
                Image(system: .sparkles)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.accent)
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
        }
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

// (Removed old InspirationButtonStyle — replaced by tactile styles.)

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
