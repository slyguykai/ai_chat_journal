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
            content
        }
        .navigationBarHidden(true)
        .task { await viewModel.load() }
    }
    
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.l) {
                header
                searchField
                if viewModel.filtered.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: AppSpacing.m) {
                        ForEach(viewModel.filtered) { entry in
                            EntryRow(entry: entry)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(relativeDate(entry.timestamp)), \(entryTitle(entry))")
                        }
                    }
                }
            }
            .padding(AppSpacing.m)
        }
        .appTheme()
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
            Image(systemName: "magnifyingglass").foregroundColor(AppColors.inkSecondary)
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
    
    private var emptyState: some View {
        VStack(alignment: .center, spacing: AppSpacing.s) {
            Image(systemName: "book").font(.system(size: 40, weight: .semibold)).foregroundColor(AppColors.inkSecondary)
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
}

private struct EntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        GlassCard(cornerRadius: AppRadii.large) {
            HStack(alignment: .top, spacing: AppSpacing.m) {
                Image(systemName: "face.smiling")
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
