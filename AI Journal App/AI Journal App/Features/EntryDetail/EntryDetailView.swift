//
//  EntryDetailView.swift
//  AI Journal App
//

import SwiftUI

struct EntryDetailView: View {
    @StateObject private var viewModel: EntryDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: EntryDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.m) {
                header
                Text(viewModel.entry.text)
                    .body()
                    .foregroundColor(AppColors.inkPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppSpacing.m)
        }
        .background(AppColors.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ShareLink(item: viewModel.entry.text) { Label("Share", systemImage: "square.and.arrow.up") }
                    Button(role: .destructive) {
                        Task {
                            try? await viewModel.delete()
                            dismiss()
                        }
                    } label: { Label("Delete", systemImage: "trash") }
                } label: {
                    Image(system: .ellipsis)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.inkPrimary)
                }
            }
        }
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: AppSpacing.m) {
            if let mood = viewModel.entry.mood {
                MoodEmojiView(type: mood, size: .large)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.entry.timestamp, style: .date)
                    .caption(weight: .medium)
                    .foregroundColor(AppColors.inkSecondary)
                Text(viewModel.entry.timestamp, style: .time)
                    .caption()
                    .foregroundColor(AppColors.inkSecondary)
            }
            Spacer()
        }
    }
}

#Preview("Entry Detail") {
    let entry = JournalEntry(text: "A nice walk and a good coffee.", mood: .happy)
    return NavigationStack { EntryDetailView(viewModel: EntryDetailViewModel(entry: entry, entryStore: MockEntryStore())) }
}
