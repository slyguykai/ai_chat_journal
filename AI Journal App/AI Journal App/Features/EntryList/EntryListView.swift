//
//  EntryListView.swift
//  AI Journal App
//
//  Journal entry list with glass-style cards
//

import SwiftUI

/// Journal entry list view
struct EntryListView: View {
    @StateObject private var viewModel: EntryListViewModel
    
    init(viewModel: EntryListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.canvas.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: AppSpacing.m) {
                        if viewModel.entries.isEmpty && !viewModel.isLoading {
                            EmptyStateView()
                        } else {
                            ForEach(viewModel.entries) { entry in
                                EntryCard(entry: entry) {
                                    viewModel.deleteEntry(entry)
                                }
                            }
                        }
                    }
                    .padding(AppSpacing.m)
                }
                .refreshable {
                    viewModel.loadEntries()
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading entries...")
                        .padding()
                        .background(AppColors.surface)
                        .cornerRadius(AppRadii.medium)
                }
            }
            .navigationTitle("Journal Entries")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Entry Card

struct EntryCard: View {
    let entry: JournalEntry
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            // Header with mood and timestamp
            HStack {
                if let mood = entry.mood {
                    MoodEmojiView(type: mood, size: .small)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.timestamp, style: .date)
                        .caption(weight: .medium)
                        .foregroundColor(AppColors.inkSecondary)
                    
                    Text(entry.timestamp, style: .time)
                        .caption()
                        .foregroundColor(AppColors.inkSecondary)
                }
                
                Spacer()
                
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(AppColors.inkSecondary)
                }
                .frame(width: 44, height: 44)
                .accessibilityLabel("Delete entry")
            }
            
            // Entry text
            Text(entry.text)
                .body()
                .foregroundColor(AppColors.inkPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Summary if available
            if let summary = entry.summary {
                Text(summary)
                    .caption()
                    .foregroundColor(AppColors.inkSecondary)
                    .padding(.top, AppSpacing.xs)
                    .italic()
            }
        }
        .padding(AppSpacing.m)
        .background(GlassCardBackground())
        .cornerRadius(AppRadii.large)
    }
}

// MARK: - Glass Card Background

struct GlassCardBackground: View {
    var body: some View {
        ZStack {
            // Base surface
            AppColors.surface
            
            // Glass effect overlay
            Rectangle()
                .fill(.white.opacity(0.12))
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.large)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
        }
        .cornerRadius(AppRadii.large)
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: AppSpacing.m) {
            Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundColor(AppColors.inkSecondary)
            
            Text("No Entries Yet")
                .titleM(weight: .semibold)
                .foregroundColor(AppColors.inkPrimary)
            
            Text("Start journaling by tapping the + button")
                .body()
                .foregroundColor(AppColors.inkSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
    }
}

// MARK: - Preview

#Preview("Entry List - Light") {
    EntryListView(
        viewModel: EntryListViewModel(entryStore: MockEntryStore())
    )
}

#Preview("Entry List - Dark") {
    EntryListView(
        viewModel: EntryListViewModel(entryStore: MockEntryStore())
    )
    .preferredColorScheme(.dark)
}

#Preview("Empty State") {
    struct EmptyPreview: View {
        var body: some View {
            EntryListView(
                viewModel: {
                    let store = MockEntryStore()
                    store.entries = []
                    return EntryListViewModel(entryStore: store)
                }()
            )
        }
    }
    
    return EmptyPreview()
}
