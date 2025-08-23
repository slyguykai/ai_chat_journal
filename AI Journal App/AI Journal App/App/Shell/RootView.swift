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
                            Image(systemName: "").hidden()
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
                            accessibilityLabel: TabItem.brainDump.accessibilityLabel,
                            accessibilityHint: TabItem.brainDump.accessibilityHint
                        )
                        .accessibilityLabel(TabItem.brainDump.accessibilityLabel)
                        .accessibilityHint(TabItem.brainDump.accessibilityHint)
                        .scaleEffect(showBrainDumpTransition ? 1.1 : 1.0)
                        .opacity(showBrainDumpTransition ? 0.8 : 1.0)
                        .frame(minWidth: 44, minHeight: 44)
                        Spacer()
                        Spacer()
                    }
                    .padding(.bottom, 12) // in-line with tab bar icons
                }
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Tab Item View

struct TabItemView: View {
    let tab: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: tab.systemImage)
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
