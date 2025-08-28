//
//  OnboardingPermissionsView.swift
//  AI Journal App
//
//  Placeholder onboarding view for permission requests
//

import SwiftUI

/// Onboarding view for requesting app permissions
struct OnboardingPermissionsView: View {
    @State private var microphoneStatus: PermissionStatus = .notDetermined
    @State private var speechStatus: PermissionStatus = .notDetermined
    @State private var notificationStatus: PermissionStatus = .notDetermined
    @State private var isRequestingPermissions = false
    
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            // Header
            VStack(spacing: AppSpacing.m) {
                Image(systemName: "lock.shield")
                    .font(.system(size: 64))
                    .foregroundColor(AppColors.coral)
                
                Text("Enable Features")
                    .titleXL(weight: .bold)
                    .foregroundColor(AppColors.inkPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Grant permissions to unlock the full AI Journal experience")
                    .body()
                    .foregroundColor(AppColors.inkSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Permission Cards
            VStack(spacing: AppSpacing.m) {
                PermissionCard(
                    icon: "mic.fill",
                    title: "Microphone Access",
                    description: "Record voice entries for quick thought capture",
                    status: microphoneStatus
                )
                
                PermissionCard(
                    icon: "waveform",
                    title: "Speech Recognition",
                    description: "Automatically transcribe voice recordings to text",
                    status: speechStatus
                )
                
                PermissionCard(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Daily reminders to maintain your journaling habit",
                    status: notificationStatus
                )
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: AppSpacing.m) {
                Button("Grant Permissions") {
                    requestAllPermissions()
                }
                .buttonStyle(TactilePrimaryButtonStyle())
                .disabled(isRequestingPermissions)
                
                Button("Skip for Now") {
                    // TODO: Navigate to main app
                }
                .buttonStyle(TactileSecondaryButtonStyle())
            }
            
            if isRequestingPermissions {
                HStack(spacing: AppSpacing.s) {
                    ProgressView()
                        .scaleEffect(0.8)
                    
                    Text("Requesting permissions...")
                        .body()
                        .foregroundColor(AppColors.inkSecondary)
                }
            }
        }
        .padding(AppSpacing.m)
        .background(AppColors.canvas)
        .task {
            await checkCurrentPermissions()
        }
    }
    
    // MARK: - Private Methods
    
    private func requestAllPermissions() {
        isRequestingPermissions = true
        
        Task {
            let results = await PermissionManager.requestAllPermissions()
            
            await MainActor.run {
                microphoneStatus = results[.microphone] ?? .notDetermined
                speechStatus = results[.speechRecognition] ?? .notDetermined
                notificationStatus = results[.notifications] ?? .notDetermined
                isRequestingPermissions = false
            }
        }
    }
    
    private func checkCurrentPermissions() async {
        microphoneStatus = PermissionManager.microphoneStatus()
        speechStatus = PermissionManager.speechRecognitionStatus()
        notificationStatus = await PermissionManager.notificationStatus()
    }
}

// MARK: - Permission Card

struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let status: PermissionStatus
    
    var body: some View {
        HStack(spacing: AppSpacing.m) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .body(weight: .semibold)
                    .foregroundColor(AppColors.inkPrimary)
                
                Text(description)
                    .caption()
                    .foregroundColor(AppColors.inkSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Status Indicator
            statusIndicator
        }
        .padding(AppSpacing.m)
        .background(AppColors.surface)
        .cornerRadius(AppRadii.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadii.medium)
                .stroke(AppColors.divider, lineWidth: 1)
        )
    }
    
    private var iconBackgroundColor: Color {
        switch status {
        case .authorized:
            return AppColors.mint.opacity(0.2)
        case .denied, .restricted:
            return AppColors.coral.opacity(0.2)
        case .notDetermined:
            return AppColors.divider.opacity(0.2)
        }
    }
    
    private var iconColor: Color {
        switch status {
        case .authorized:
            return AppColors.mint
        case .denied, .restricted:
            return AppColors.coral
        case .notDetermined:
            return AppColors.inkSecondary
        }
    }
    
    @ViewBuilder
    private var statusIndicator: some View {
        switch status {
        case .authorized:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppColors.mint)
        case .denied, .restricted:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(AppColors.coral)
        case .notDetermined:
            Image(systemName: "circle")
                .foregroundColor(AppColors.inkSecondary)
        }
    }
}

// MARK: - Preview

#Preview("Onboarding Permissions") {
    OnboardingPermissionsView()
}

#Preview("Permissions - Dark Mode") {
    OnboardingPermissionsView()
        .preferredColorScheme(.dark)
}
