//
//  LibraryView.swift
//  AI Journal App
//
//  Library screen: search + list of entries with glass cards
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea(.container, edges: [.top, .bottom])
                .allowsHitTesting(false)
            content
        }
        .navigationBarHidden(true)
        .task { await viewModel.load() }
    }
    
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.l) {
                topBar
                header
                searchField
                metricsRow
                sectionHeader("Recent Reflections")
                if viewModel.filtered.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: AppSpacing.m) {
                        ForEach(viewModel.filtered) { entry in
                            NavigationLink {
                                EntryDetailView(viewModel: EntryDetailViewModel(entry: entry, entryStore: viewModel.entryStore))
                            } label: {
                                EntryRow(entry: entry)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task { await viewModel.delete(entry) }
                                } label: { Label("Delete", systemImage: "trash") }
                            }
                            .cardPress()
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(relativeDate(entry.timestamp)), \(entryTitle(entry))")
                        }
                    }
                }
            }
            .padding(AppSpacing.m)
            .contentShape(Rectangle())
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .appTheme()
    }
    
    private var topBar: some View {
        LibraryTopBar(viewModel: viewModel)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Your Journey").titleXL(weight: .bold).foregroundColor(AppColors.inkPrimary)
            Text("Explore your past reflections, insights, and personal growth over time.")
                .body()
                .foregroundColor(AppColors.inkSecondary)
        }
    }
    
    private var searchField: some View {
        TactileSearchField(text: $viewModel.searchText, placeholder: "Search entries")
    }
    
    private var metricsRow: some View {
        HStack(spacing: AppSpacing.m) {
            MetricTile(title: "Total Entries", value: "\(viewModel.entries.count)")
            MetricTile(title: "Streak Days", value: "\(computeStreakDays(viewModel.entries))")
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .titleM(weight: .bold)
            .foregroundColor(AppColors.inkPrimary)
            .padding(.top, AppSpacing.s)
    }
    
    private var emptyState: some View {
        VStack(alignment: .center, spacing: AppSpacing.s) {
            Image(system: .book)
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(AppColors.inkSecondary)
            Text("No entries yet").titleM(weight: .semibold).foregroundColor(AppColors.inkPrimary)
            Text("Start your first reflection from the Brain Dump tab.")
                .body()
                .foregroundColor(AppColors.inkSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.l)
    }
    
    private func entryTitle(_ entry: JournalEntry) -> String {
        if let summary = entry.summary, !summary.isEmpty { return summary }
        let text = entry.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return String(text.prefix(40))
    }
    
    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func computeStreakDays(_ entries: [JournalEntry]) -> Int {
        let daysWithEntries = Set(entries.map { Calendar.current.startOfDay(for: $0.timestamp) })
        var streak = 0
        var currentDay = Calendar.current.startOfDay(for: Date())
        while daysWithEntries.contains(currentDay) {
            streak += 1
            if let prev = Calendar.current.date(byAdding: .day, value: -1, to: currentDay) { currentDay = prev } else { break }
        }
        return streak
    }
}

private struct EntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        SurfaceCard(cornerRadius: AppRadii.large) {
            HStack(alignment: .top, spacing: AppSpacing.m) {
                Image(system: .faceSmiling)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.inkSecondary)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(title)
                            .titleM(weight: .semibold)
                            .foregroundColor(AppColors.inkPrimary)
                        Spacer()
                        Text(time)
                            .caption()
                            .foregroundColor(AppColors.inkSecondary)
                    }
                    Text(entry.text)
                        .body()
                        .foregroundColor(AppColors.inkSecondary)
                        .lineLimit(2)
                }
            }
        }
        .accessibilityLabel("\(title), \(time)")
    }
    
    private var title: String {
        if let summary = entry.summary, !summary.isEmpty { return summary }
        let text = entry.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return String(text.prefix(40))
    }
    
    private var time: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: entry.timestamp, relativeTo: Date())
    }
}

private struct MetricTile: View {
    let title: String
    let value: String
    
    var body: some View {
        SurfaceCard(cornerRadius: AppRadii.large) {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text(title).body().foregroundColor(AppColors.inkPrimary)
                Text(value).titleXL(weight: .bold).foregroundColor(AppColors.inkPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) \(value)")
    }
}

private struct LibraryTopBar: View {
    @ObservedObject var viewModel: LibraryViewModel
    @State private var showSettings = false
    @State private var shareItems: [Any]? = nil
    
    var body: some View {
        HStack {
            Image(system: .chevronLeft)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.inkPrimary.opacity(0.6))
            Spacer()
            HStack(spacing: AppSpacing.s) {
                Image(system: .book)
                    .font(.system(size: 16, weight: .semibold))
                Text("My Library").body(weight: .semibold)
            }
            .foregroundColor(AppColors.inkPrimary)
            .padding(.horizontal, AppSpacing.l)
            .padding(.vertical, AppSpacing.s)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .accessibilityLabel("My Library")
            Spacer()
            Menu {
                Button("Export JSON") { export() }
                Button("Settings") { showSettings = true }
                Button("About") {}
            } label: {
                Image(system: .ellipsis)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.inkPrimary.opacity(0.6))
            }
        }
        .sheet(isPresented: Binding(get: { shareItems != nil }, set: { if !$0 { shareItems = nil } })) {
            if let shareItems { ShareSheet(items: shareItems) }
        }
        .sheet(isPresented: $showSettings) { NavigationStack { SettingsView() } }
    }
    
    private func export() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(viewModel.entries), let text = String(data: data, encoding: .utf8) {
            shareItems = [text]
        }
    }
}

// MARK: - Previews

#Preview("Library - Mock") {
    let mock = MockEntryStore()
    let vm = LibraryViewModel(entryStore: mock)
    return LibraryView(viewModel: vm)
}

#Preview("Library - Empty") {
    class EmptyStore: MockEntryStore {
        override init() { super.init(); self.entries = [] }
    }
    let vm = LibraryViewModel(entryStore: EmptyStore())
    return LibraryView(viewModel: vm)
}
