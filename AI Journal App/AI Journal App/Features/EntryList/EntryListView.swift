//
//  EntryListView.swift
//  AI Journal App
//
//  Displays a vertical list of entries using glass cards
//

import SwiftUI

struct EntryListView: View {
    let entries: [JournalEntry]
    
    var body: some View {
        VStack(spacing: AppSpacing.m) {
            ForEach(entries) { entry in
                SurfaceCard(cornerRadius: AppRadii.large) {
                    HStack(alignment: .top, spacing: AppSpacing.m) {
                        Image(system: .faceSmiling)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.inkSecondary)
                            .padding(.top, 2)
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(title(for: entry))
                                .titleM(weight: .semibold)
                                .foregroundColor(AppColors.inkPrimary)
                            Text(entry.text)
                                .body()
                                .foregroundColor(AppColors.inkSecondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        Text(relativeDate(entry.timestamp))
                            .caption()
                            .foregroundColor(AppColors.inkSecondary)
                    }
                }
            }
        }
    }
    
    private func title(for entry: JournalEntry) -> String {
        if let summary = entry.summary, !summary.isEmpty { return summary }
        return String(entry.text.trimmingCharacters(in: .whitespacesAndNewlines).prefix(40))
    }
    
    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
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
    let store = MockEntryStore()
    return EntryListView(entries: store.entries)
}

#Preview("Entry List - Dark") {
    let store = MockEntryStore()
    return EntryListView(entries: store.entries)
        .preferredColorScheme(.dark)
}

#Preview("Empty State") {
    EntryListView(entries: [])
}
