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
            GradientBackground.blushLavender
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
                            EntryRow(entry: entry)
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
            Image(system: .ellipsis)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppColors.inkPrimary.opacity(0.6))
        }
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
        HStack(spacing: AppSpacing.s) {
            Image(system: .magnifyingglass).foregroundColor(AppColors.inkSecondary)
            TextField("Search entries", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(AppColors.inkPrimary)
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, AppSpacing.s)
        .background(
            RoundedRectangle(cornerRadius: AppRadii.large)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .accessibilityLabel("Search past entries")
    }
    
    private var metricsRow: some View {
        HStack(spacing: AppSpacing.m) {
            MetricTile(title: "Total Entries", value: "\(viewModel.entries.count)", gradient: LinearGradient(
                gradient: Gradient(colors: [AppColors.sky.opacity(0.8), AppColors.lavender.opacity(0.7)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
            MetricTile(title: "Streak Days", value: "\(computeStreakDays(viewModel.entries))", gradient: LinearGradient(
                gradient: Gradient(colors: [AppColors.blush.opacity(0.85), AppColors.apricot.opacity(0.85)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
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
        GlassCard(cornerRadius: AppRadii.large) {
            HStack(alignment: .top, spacing: AppSpacing.m) {
                Image(system: .faceSmiling)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.inkSecondary)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack {
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
                        .lineLimit(2)
                        .foregroundColor(AppColors.inkSecondary)
                }
            }
        }
        .frame(minHeight: 44)
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
    let gradient: LinearGradient
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            Text(title).body().foregroundColor(AppColors.inkPrimary)
            Text(value).titleXL(weight: .bold).foregroundColor(AppColors.inkPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppRadii.large)
                .fill(gradient)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) \(value)")
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
