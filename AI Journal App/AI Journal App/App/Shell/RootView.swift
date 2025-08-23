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
        case .today: return "Today"
        case .inspire: return "Inspire"
        case .brainDump: return "Brain Dump"
        case .library: return "Library"
        case .stats: return "Stats"
        }
    }
    
    var systemImage: String {
        switch self {
        case .today: return "house"
        case .inspire: return "sparkles"
        case .brainDump: return "plus.circle.fill"
        case .library: return "books.vertical"
        case .stats: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .today: return "Today view"
        case .inspire: return "Inspire view"
        case .brainDump: return "Brain dump view"
        case .library: return "Library view"
        case .stats: return "Statistics view"
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
                // Today Tab (from Features/Today)
                TodayView()
                    .tabItem {
                        TabItemView(tab: .today, isSelected: selectedTab == .today)
                    }
                    .tag(AppTab.today)
                
                // Inspire Tab
                InspireView()
                    .tabItem {
                        TabItemView(tab: .inspire, isSelected: selectedTab == .inspire)
                    }
                    .tag(AppTab.inspire)
                
                // Brain Dump Tab (Center - hidden tab item)
                BrainDumpView(viewModel: container.makeBrainDumpViewModel())
                    .tabItem {
                        Image(systemName: "").hidden()
                        Text("").hidden()
                    }
                    .tag(AppTab.brainDump)
                
                // Library Tab
                LibraryView(viewModel: LibraryViewModel(entryStore: container.entryStore))
                    .tabItem {
                        TabItemView(tab: .library, isSelected: selectedTab == .library)
                    }
                    .tag(AppTab.library)
                
                // Stats Tab
                StatsView(viewModel: StatsViewModel())
                    .tabItem {
                        TabItemView(tab: .stats, isSelected: selectedTab == .stats)
                    }
                    .tag(AppTab.stats)
            }
            .accentColor(AppColors.coral)
            
            // Floating center button overlay - always visible, aligned with tab bar
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Spacer()
                    CircularCTA(
                        icon: "plus",
                        size: .large,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) { showBrainDumpTransition = true }
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
                    Spacer()
                    Spacer()
                }
                .padding(.bottom, 12) // in-line with tab bar icons
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

#Preview("Root View - Light") { RootView() }
#Preview("Root View - Dark") { RootView().preferredColorScheme(.dark) }
