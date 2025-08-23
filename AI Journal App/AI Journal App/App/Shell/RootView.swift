//
//  RootView.swift
//  AI Journal App
//
//  Main tabbed shell interface with center Quick Add action
//

import SwiftUI

/// Main tab navigation options
enum AppTab: String, CaseIterable {
    case today = "today"
    case inspire = "inspire"
    case brainDump = "brain_dump"
    case library = "library"
    case stats = "stats"
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .inspire:
            return "Inspire"
        case .brainDump:
            return "Brain Dump"
        case .library:
            return "Library"
        case .stats:
            return "Stats"
        }
    }
    
    var systemImage: String {
        switch self {
        case .today:
            return "house"
        case .inspire:
            return "sparkles"
        case .brainDump:
            return "plus.circle.fill"
        case .library:
            return "books.vertical"
        case .stats:
            return "chart.line.uptrend.xyaxis"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .today:
            return "Today view"
        case .inspire:
            return "Inspire view"
        case .brainDump:
            return "Brain dump view"
        case .library:
            return "Library view"
        case .stats:
            return "Statistics view"
        }
    }
}

/// Main root view with tabbed navigation
struct RootView: View {
    @StateObject private var container = AppContainer()
    @State private var selectedTab: AppTab = .today
    @State private var showBrainDumpTransition = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Today Tab
                TodayView()
                    .tabItem {
                        TabItemView(
                            tab: .today,
                            isSelected: selectedTab == .today
                        )
                    }
                    .tag(AppTab.today)
                
                // Inspire Tab
                InspireView()
                    .tabItem {
                        TabItemView(
                            tab: .inspire,
                            isSelected: selectedTab == .inspire
                        )
                    }
                    .tag(AppTab.inspire)
                
                // Brain Dump Tab (Center - hidden tab item)
                BrainDumpView(viewModel: container.makeBrainDumpViewModel())
                    .tabItem {
                        // Empty/invisible tab item for Brain Dump
                        Image(systemName: "")
                            .hidden()
                        Text("")
                            .hidden()
                    }
                    .tag(AppTab.brainDump)
                
                // Library Tab
                EntryListView(viewModel: container.makeEntryListViewModel())
                    .tabItem {
                        TabItemView(
                            tab: .library,
                            isSelected: selectedTab == .library
                        )
                    }
                    .tag(AppTab.library)
                
                // Stats Tab
                StatsView()
                    .tabItem {
                        TabItemView(
                            tab: .stats,
                            isSelected: selectedTab == .stats
                        )
                    }
                    .tag(AppTab.stats)
            }
            .accentColor(AppColors.coral)
            
            // Floating center button overlay - positioned in middle tab slot
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    // Space for first tab (Today)
                    Spacer()
                    
                    // Space for second tab (Inspire)
                    Spacer()
                    
                    // Center button in middle tab position
                    CircularCTA(
                        icon: "plus",
                        size: .large,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showBrainDumpTransition = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                selectedTab = .brainDump
                                showBrainDumpTransition = false
                            }
                        },
                        accessibilityLabel: "Brain Dump",
                        accessibilityHint: "Open brain dump to quickly capture your thoughts"
                    )
                    .scaleEffect(showBrainDumpTransition ? 1.1 : 1.0)
                    .opacity(showBrainDumpTransition ? 0.8 : 1.0)
                    
                    // Space for fourth tab (Library)
                    Spacer()
                    
                    // Space for fifth tab (Stats)
                    Spacer()
                }
                .padding(.bottom, 20) // Position to align with tab icons
                .padding(.horizontal, 0) // Let spacers handle distribution
            }
        }
    }
}

// MARK: - Tab Item View

struct TabItemView: View {
    let tab: AppTab
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: tab.systemImage)
                .font(.system(size: 20, weight: .medium))
            
            Text(tab.title)
                .font(.caption2)
        }
        .accessibilityLabel(tab.accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Tab Content Views

struct TodayView: View {
    var body: some View {
        ZStack {
            GradientBackground.sunrise
            
            VStack(spacing: AppSpacing.l) {
                VStack(spacing: AppSpacing.s) {
                    Text("Good Morning!")
                        .titleXL(weight: .bold)
                        .foregroundColor(.white)
                    
                    Text("Ready to start your day?")
                        .body()
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Today's stats placeholder
                VStack(spacing: AppSpacing.m) {
                    HStack(spacing: AppSpacing.m) {
                        StatCard(title: "Streak", value: "5", subtitle: "days")
                        StatCard(title: "Entries", value: "12", subtitle: "this week")
                    }
                }
                .padding(.bottom, AppSpacing.xl)
            }
            .padding(AppSpacing.m)
        }
        .appTheme()
    }
}



// InspireView is now defined in Features/Inspire/InspireView.swift

struct StatsView: View {
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Text("Statistics")
                .titleL(weight: .semibold)
                .foregroundColor(AppColors.inkPrimary)
            
            Text("Insights and analytics")
                .body()
                .foregroundColor(AppColors.inkSecondary)
            
            Spacer()
        }
        .padding(AppSpacing.m)
        .background(AppColors.canvas)
        .appTheme()
    }
}

// MARK: - Supporting Components

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(value)
                .titleL(weight: .bold)
                .foregroundColor(AppColors.inkPrimary)
            
            Text(title)
                .body(weight: .medium)
                .foregroundColor(AppColors.inkPrimary)
            
            Text(subtitle)
                .caption()
                .foregroundColor(AppColors.inkSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.m)
        .background(AppColors.surface.opacity(0.9))
        .cornerRadius(AppRadii.medium)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// PromptCard removed - InspireView now uses InspirationCard

// MARK: - Preview

#Preview("Root View - Light") {
    RootView()
}

#Preview("Root View - Dark") {
    RootView()
        .preferredColorScheme(.dark)
}

#Preview("Today View Only") {
    TodayView()
}
