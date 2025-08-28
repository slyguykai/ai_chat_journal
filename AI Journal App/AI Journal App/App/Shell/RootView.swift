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
    @State private var chrome = ChromeState()
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    // Today Tab (from Features/Today)
                    TodayView(viewModel: TodayViewModel(entryStore: container.entryStore))
                        .background(scrollProbe())
                        .onPreferenceChange(ScrollOffsetKey.self) { updateCondensed(from: $0) }
                        .tabItem { TabItemView(tab: .today, isSelected: selectedTab == .today) }
                        .tag(TabItem.today)
                    
                    // Inspire Tab
                    InspireView()
                        .background(scrollProbe())
                        .onPreferenceChange(ScrollOffsetKey.self) { updateCondensed(from: $0) }
                        .tabItem { TabItemView(tab: .inspire, isSelected: selectedTab == .inspire) }
                        .tag(TabItem.inspire)
                    
                    // Brain Dump Tab (Center - hidden tab item)
                    BrainDumpView(viewModel: container.makeBrainDumpViewModel())
                        .background(scrollProbe())
                        .onPreferenceChange(ScrollOffsetKey.self) { updateCondensed(from: $0) }
                        .tabItem { Image(system: .questionmark).hidden(); Text("").hidden() }
                        .tag(TabItem.brainDump)
                    
                    // Library Tab
                    LibraryView(viewModel: LibraryViewModel(entryStore: container.entryStore))
                        .background(scrollProbe())
                        .onPreferenceChange(ScrollOffsetKey.self) { updateCondensed(from: $0) }
                        .tabItem { TabItemView(tab: .library, isSelected: selectedTab == .library) }
                        .tag(TabItem.library)
                    
                    // Stats Tab
                    StatsView(viewModel: StatsViewModel(entryStore: container.entryStore))
                        .background(scrollProbe())
                        .onPreferenceChange(ScrollOffsetKey.self) { updateCondensed(from: $0) }
                        .tabItem { TabItemView(tab: .stats, isSelected: selectedTab == .stats) }
                        .tag(TabItem.stats)
                }
                .accentColor(AppColors.accent)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                // Place premium glass behind content & tabs
                .background(alignment: .bottom) {
                    if !chrome.isKeyboardUp {
                        TabBarBackgroundView(selectedIndex: tabIndex(for: selectedTab))
                            .environment(chrome)
                    }
                }
            }
            // Floating CTA overlay above the glass, limited hit area
            .overlay(alignment: .bottom) {
                if !chrome.isKeyboardUp {
                    CircularCTA(
                        icon: "plus",
                        size: .large,
                        action: {
                            Haptics.light()
                            withAnimation(.easeInOut(duration: 0.2)) { showBrainDumpTransition = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                                    selectedTab = .brainDump
                                    showBrainDumpTransition = false
                                }
                            }
                        },
                        accessibilityLabel: TabItem.brainDump.accessibilityLabel,
                        accessibilityHint: TabItem.brainDump.accessibilityHint,
                        backgroundColor: .black
                    )
                    .scaleEffect(showBrainDumpTransition ? 1.05 : 1.0)
                    .opacity(showBrainDumpTransition ? 0.9 : 1.0)
                    .padding(.bottom, 12)
                }
            }
            .onReceive(keyboardObserver.$isKeyboardPresented) { isUp in
                chrome.isKeyboardUp = isUp
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .onReceive(NotificationCenter.default.publisher(for: AppNotification.navigateToBrainDump)) { _ in
            withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) { selectedTab = .brainDump }
        }
    }
    
    private func scrollProbe() -> some View {
        GeometryReader { proxy in
            let offset = -proxy.frame(in: .named("scroll")).origin.y
            Color.clear.preference(key: ScrollOffsetKey.self, value: offset)
        }
    }
    
    private func updateCondensed(from offset: CGFloat) {
        withAnimation(.easeInOut(duration: 0.2)) {
            chrome.condensedTab = offset > 40
        }
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
        VStack(spacing: 2) {
            Image(systemName: symbolName)
                .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .black : AppColors.inkPrimary.opacity(0.6))
                .frame(minWidth: 44, minHeight: 28)
            Text(tab.title)
                .font(.caption2)
                .foregroundColor(isSelected ? .black : AppColors.inkPrimary.opacity(0.6))
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .accessibilityLabel(tab.accessibilityLabel)
        .accessibilityHint(tab.accessibilityHint)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    private var symbolName: String {
        switch tab {
        case .today:
            return isSelected ? "envelope.fill" : "envelope"
        case .inspire:
            return isSelected ? "lightbulb.fill" : "lightbulb"
        case .brainDump:
            return isSelected ? "plus.circle.fill" : "plus.circle"
        case .library:
            return isSelected ? "book.fill" : "book"
        case .stats:
            return isSelected ? "book.closed.fill" : "book.closed"
        }
    }
}

#Preview("Root View - Light") { RootView() }
#Preview("Root View - Dark") { RootView().preferredColorScheme(.dark) }
