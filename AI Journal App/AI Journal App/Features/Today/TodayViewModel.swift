//
//  TodayViewModel.swift
//  AI Journal App
//

import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published private(set) var hasEntryToday: Bool = false
    private let entryStore: any EntryStore
    
    init(entryStore: any EntryStore) {
        self.entryStore = entryStore
    }
    
    func refresh() async {
        do { try await entryStore.fetchEntries() } catch {}
        let entries = entryStore.entries
        let today = Calendar.current.startOfDay(for: Date())
        hasEntryToday = entries.contains { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
    }
}

