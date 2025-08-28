//
//  StatsViewModel.swift
//  AI Journal App
//
//  Mock stats view model providing a 7-day mood series and KPIs
//

import Foundation
import SwiftUI

struct MoodPoint: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let moodScore: Double // 0-100
}

@MainActor
final class StatsViewModel: ObservableObject {
    @Published private(set) var last7Days: [MoodPoint] = []
    @Published private(set) var stressPercent: Int = 0
    @Published private(set) var avgSleepHours: Double = 0
    
    private let entryStore: (any EntryStore)?
    
    init(entryStore: (any EntryStore)? = nil) {
        self.entryStore = entryStore
        if entryStore == nil { generateMock() } else { Task { await refresh() } }
    }
    
    func generateMock(reference: Date = Date()) {
        let calendar = Calendar.current
        var series: [MoodPoint] = []
        for i in (0..<7).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -i, to: reference) else { continue }
            let base = 60.0 + Double(Int.random(in: -15...15))
            series.append(MoodPoint(date: day, moodScore: max(0, min(100, base))))
        }
        last7Days = series
        stressPercent = Int.random(in: 18...42)
        avgSleepHours = Double(Int.random(in: 6...8)) + (Bool.random() ? 0.5 : 0)
    }
    
    func refresh() async {
        guard let entryStore else { return }
        do { try await entryStore.fetchEntries() } catch {}
        let entries = entryStore.entries
        computeSeries(from: entries)
        computeKPIs(from: entries)
    }
    
    private func computeSeries(from entries: [JournalEntry]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var series: [MoodPoint] = []
        for offset in (0..<7).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            let dayEntries = entries.filter { calendar.isDate($0.timestamp, inSameDayAs: day) }
            let moodValues = dayEntries.compactMap { $0.mood?.moodScore }
            let avg = moodValues.isEmpty ? 60.0 : Double(moodValues.reduce(0, +)) / Double(moodValues.count) * 10.0
            series.append(MoodPoint(date: day, moodScore: min(100, max(0, avg))))
        }
        last7Days = series
    }
    
    private func computeKPIs(from entries: [JournalEntry]) {
        // As placeholders: stress inversely proportional to mood; sleep remains a static heuristic
        let moods = entries.compactMap { $0.mood?.moodScore }
        if moods.isEmpty { stressPercent = 30 } else {
            let avgMood = Double(moods.reduce(0, +)) / Double(moods.count)
            stressPercent = Int(max(10, min(90, 100 - avgMood * 10)))
        }
        avgSleepHours = 7.0
    }
}
