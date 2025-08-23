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
    
    init() {
        generateMock()
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
}
