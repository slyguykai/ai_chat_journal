//
//  NotificationManager.swift
//  AI Journal App
//

import Foundation
import UserNotifications

enum AppNotification {
    static let navigateToBrainDump = Notification.Name("NavigateToBrainDump")
}

struct NotificationManager {
    static func scheduleReminder(in seconds: TimeInterval, title: String, body: String) async {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(5, seconds), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        do { try await center.add(request) } catch { print("Failed to schedule notification: \(error)") }
    }
    
    static func scheduleDailyReminder(hour: Int, minute: Int) async {
        let center = UNUserNotificationCenter.current()
        _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        let content = UNMutableNotificationContent()
        content.title = "Jot a thought"
        content.body = "Take a minute to reflect today."
        content.sound = .default
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily.reminder.journal", content: content, trigger: trigger)
        do { try await center.add(request) } catch { print("Failed to schedule daily: \(error)") }
    }
    
    static func clearScheduledReminders() async {
        let center = UNUserNotificationCenter.current()
        await center.removeAllPendingNotificationRequests()
    }
}
