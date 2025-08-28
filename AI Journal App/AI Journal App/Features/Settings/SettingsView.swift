//
//  SettingsView.swift
//  AI Journal App
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Feedback").caption()) {
                Toggle(isOn: $viewModel.hapticsEnabled) {
                    Label("Haptics", systemImage: "iphone.radiowaves.left.and.right")
                }
            }
            
            Section(header: Text("Reminders").caption()) {
                Toggle(isOn: $viewModel.dailyReminderEnabled) {
                    Label("Daily Reminder", systemImage: "bell")
                }
                if viewModel.dailyReminderEnabled {
                    DatePicker("Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                }
                Button("Apply Reminder Settings") {
                    Task { await viewModel.applyReminderSettings() }
                }
            }
            
            Section(header: Text("About").caption()) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview("Settings") {
    NavigationStack { SettingsView() }
}

