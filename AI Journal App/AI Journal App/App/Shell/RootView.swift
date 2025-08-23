//
//  RootView.swift
//  AI Journal App
//
//  Main tabbed shell interface with center Quick Add action
//

import SwiftUI

/// Main root view with tabbed navigation
struct RootView: View {
    @StateObject private var container = AppContainer()
    @State private var selectedTab: TabItem = .today
    @State private var showBrainDumpTransition = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    // Today Tab (from Features/Today)
                    TodayView()
                        .tabItem {
                            TabItemView(tab: .today, isSelected: selectedTab == .today)
                        }
                        .tag(TabItem.today)
                    
                    // Inspire Tab
                    InspireView()
                        .tabItem {
                            TabItemView(tab: .inspire, isSelected: selectedTab == .inspire)
                        }
                        .tag(TabItem.inspire)
                    
                    // Brain Dump Tab (Center - hidden tab item)
                    BrainDumpView(viewModel: container.makeBrainDumpViewModel())
                        .tabItem {
                            Image(system: .questionmark).hidden()
                            Text("").hidden()
                        }
                        .tag(TabItem.brainDump)
                    
                    // Library Tab
                    LibraryView(viewModel: LibraryViewModel(entryStore: container.entryStore))
                        .tabItem {
                            TabItemView(tab: .library, isSelected: selectedTab == .library)
                        }
                        .tag(TabItem.library)
                    
                    // Stats Tab
                    StatsView(viewModel: StatsViewModel())
                        .tabItem {
                            TabItemView(tab: .stats, isSelected: selectedTab == .stats)
                        }
                        .tag(TabItem.stats)
                }
                .accentColor(AppColors.coral)
            }
            // Background glass under the tab area
            .safeAreaInset(edge: .bottom) {
                TabBarBackgroundView(selectedIndex: tabIndex(for: selectedTab))
                    .frame(height: 92)
            }
            // Floating CTA overlay above the glass
            .safeAreaInset(edge: .bottom) {
                HStack { Spacer()
                    CircularCTA(
                        icon: "plus",
                        size: .large,
                        action: {
                            Haptics.light()
                            withAnimation(.easeInOut(duration: 0.2)) { showBrainDumpTransition = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                selectedTab = .brainDump
                                showBrainDumpTransition = false
                            }
                        },
                        accessibilityLabel: TabItem.brainDump.accessibilityLabel,
                        accessibilityHint: TabItem.brainDump.accessibilityHint
                    )
                    .scaleEffect(showBrainDumpTransition ? 1.05 : 1.0)
                    .opacity(showBrainDumpTransition ? 0.9 : 1.0)
                    Spacer() }
                .padding(.bottom, 4)
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    private func tabIndex(for item: TabItem) -> Int {
        switch item {
        case .today: return 0
        case .inspire: return 1
        case .brainDump: return 2
        case .library: return 3
        case .stats: return 4
        }
    }
}

// MARK: - Tab Item View

struct TabItemView: View {
    let tab: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(system: tab.icon)
                .font(.system(size: 20, weight: .medium))
                .frame(minWidth: 44, minHeight: 44)
            Text(tab.title)
                .font(.caption2)
        }
        .accessibilityLabel(tab.accessibilityLabel)
        .accessibilityHint(tab.accessibilityHint)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview("Root View - Light") { RootView() }
#Preview("Root View - Dark") { RootView().preferredColorScheme(.dark) }
