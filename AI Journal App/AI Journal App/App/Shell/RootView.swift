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
    case brainDump = "brain_dump"
    case quickAdd = "quick_add"
    case library = "library"
    case stats = "stats"
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .brainDump:
            return "Brain Dump"
        case .quickAdd:
            return "Quick Add"
        case .library:
            return "Library"
        case .stats:
            return "Stats"
        }
    }
    
    var systemImage: String {
        switch self {
        case .today:
            return "sun.max"
        case .brainDump:
            return "brain.head.profile"
        case .quickAdd:
            return "plus"
        case .library:
            return "books.vertical"
        case .stats:
            return "chart.bar"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .today:
            return "Today view"
        case .brainDump:
            return "Brain dump view"
        case .quickAdd:
            return "Quick add entry"
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
    @State private var showingQuickAdd = false
    
    var body: some View {
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
            
            // Brain Dump Tab  
            BrainDumpView()
                .tabItem {
                    TabItemView(
                        tab: .brainDump,
                        isSelected: selectedTab == .brainDump
                    )
                }
                .tag(AppTab.brainDump)
            
            // Quick Add Tab (Center)
            Color.clear
                .tabItem {
                    TabItemView(
                        tab: .quickAdd,
                        isSelected: false,
                        isSpecial: true
                    )
                }
                .tag(AppTab.quickAdd)
            
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
        .onChange(of: selectedTab) { newTab in
            if newTab == .quickAdd {
                showingQuickAdd = true
                // Reset to previous tab to avoid staying on hidden quick add tab
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    selectedTab = .today
                }
            }
        }
        .sheet(isPresented: $showingQuickAdd) {
            QuickAddSheet()
        }
    }
}

// MARK: - Tab Item View

struct TabItemView: View {
    let tab: AppTab
    let isSelected: Bool
    var isSpecial: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            if isSpecial {
                // Special Quick Add button styling
                ZStack {
                    Circle()
                        .fill(AppColors.coral)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: tab.systemImage)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
            } else {
                // Regular tab icon
                Image(systemName: tab.systemImage)
                    .font(.system(size: 20, weight: .medium))
            }
            
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

struct BrainDumpView: View {
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Text("Brain Dump")
                .titleL(weight: .semibold)
                .foregroundColor(AppColors.inkPrimary)
            
            Text("Free-form thoughts and ideas")
                .body()
                .foregroundColor(AppColors.inkSecondary)
            
            Spacer()
        }
        .padding(AppSpacing.m)
        .background(AppColors.canvas)
        .appTheme()
    }
}

struct LibraryView: View {
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Text("Library")
                .titleL(weight: .semibold)
                .foregroundColor(AppColors.inkPrimary)
            
            Text("Your journal entries")
                .body()
                .foregroundColor(AppColors.inkSecondary)
            
            Spacer()
        }
        .padding(AppSpacing.m)
        .background(AppColors.canvas)
        .appTheme()
    }
}

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
