//
//  SettingsViewModel.swift
//  AI Journal App
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var hapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticsEnabled, forKey: Self.Keys.hapticsEnabled) }
    }
    @Published var dailyReminderEnabled: Bool {
        didSet { UserDefaults.standard.set(dailyReminderEnabled, forKey: Self.Keys.dailyReminderEnabled) }
    }
    @Published var reminderTime: Date {
        didSet { UserDefaults.standard.set(reminderTime.timeIntervalSince1970, forKey: Self.Keys.reminderTime) }
    }
    
    init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Self.Keys.hapticsEnabled) == nil {
            defaults.set(true, forKey: Self.Keys.hapticsEnabled)
        }
        hapticsEnabled = defaults.bool(forKey: Self.Keys.hapticsEnabled)
        dailyReminderEnabled = defaults.bool(forKey: Self.Keys.dailyReminderEnabled)
        let savedTime = defaults.double(forKey: Self.Keys.reminderTime)
        reminderTime = savedTime > 0 ? Date(timeIntervalSince1970: savedTime) : Self.defaultReminderTime()
    }
    
    func applyReminderSettings() async {
        if dailyReminderEnabled {
            let comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            await NotificationManager.scheduleDailyReminder(hour: comps.hour ?? 20, minute: comps.minute ?? 0)
        } else {
            await NotificationManager.clearScheduledReminders()
        }
    }
    
    private enum Keys {
        static let hapticsEnabled = "settings.hapticsEnabled"
        static let dailyReminderEnabled = "settings.dailyReminderEnabled"
        static let reminderTime = "settings.reminderTime"
    }
    
    private static func defaultReminderTime() -> Date {
        var comps = DateComponents()
        comps.hour = 20
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }
}

