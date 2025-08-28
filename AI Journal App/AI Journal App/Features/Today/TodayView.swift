//
//  TodayView.swift
//  AI Journal App
//
//  Polished Today screen with greeting, streak chip, and prompt card
//

import SwiftUI

struct TodayView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showSettings = false
    @State private var showConfetti = false
    @StateObject private var statsViewModel: TodayViewModel
    
    init(viewModel: TodayViewModel) {
        _statsViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    TopBarCapsule(
                        iconSystemName: "house",
                        title: "Today",
                        menu: AnyView(
                            Group {
                                Button("Settings") { showSettings = true }
                                Button("About") {}
                            }
                        )
                    )
                    HStack(spacing: AppSpacing.m) {
                        ProgressTrailView(mode: .today(completed: statsViewModel.hasEntryToday))
                        Spacer()
                    }
                    header
                    promptCard
                    Spacer(minLength: AppSpacing.l)
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .bottom) { Spacer().frame(height: AppSpacing.l) }
            
            if showConfetti {
                ConfettiView(duration: 1.2, colors: [AppColors.coral, AppColors.peach, AppColors.apricot])
                    .transition(.opacity)
            }
        }
        .appTheme()
        .sheet(isPresented: $showSettings) { NavigationStack { SettingsView() } }
        .task { await statsViewModel.refresh() }
    }
    
    // MARK: - Sections
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            TextEffects.words(greeting(), font: AppTypography.titleXL, weight: .bold, color: AppColors.inkPrimary)
            TextEffects.words("Keep the momentum going", font: AppTypography.body, color: AppColors.inkSecondary)
        }
    }
    
    private var promptCard: some View {
        SurfaceCard(cornerRadius: AppRadii.large) {
            VStack(alignment: .leading, spacing: AppSpacing.m) {
                Text("Mini Prompt")
                    .body(weight: .semibold)
                    .foregroundColor(AppColors.inkPrimary)
                Text("What made you smile today?")
                    .titleM(weight: .medium)
                    .foregroundColor(AppColors.inkPrimary)
                HStack(spacing: AppSpacing.m) {
                    Button("Reflect") {
                        Haptics.light()
                        NotificationCenter.default.post(name: AppNotification.navigateToBrainDump, object: nil)
                        withAnimation { showConfetti = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation { showConfetti = false } }
                    }
                    .buttonStyle(TactilePrimaryButtonStyle())
                    .accessibilityLabel("Reflect on this prompt")
                    Button("Try later") {
                        Haptics.light()
                        Task { await NotificationManager.scheduleReminder(in: 3600, title: "Jot a thought", body: "Take a minute to reflect today.") }
                    }
                    .buttonStyle(TactileSecondaryButtonStyle())
                    .accessibilityLabel("Save prompt for later")
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func greeting(date: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
}

struct StreakChip: View {
    let streakCount: Int
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "flame.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Text("\(streakCount)")
                .body(weight: .semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, AppSpacing.s)
        .background(Color.white.opacity(0.2))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadii.large)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(AppRadii.large)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Previews

#Preview("Today - Light") { TodayView(viewModel: TodayViewModel(entryStore: MockEntryStore())) }
#Preview("Today - Dark") { TodayView(viewModel: TodayViewModel(entryStore: MockEntryStore())).preferredColorScheme(.dark) }
#Preview("Today - Large Type") { TodayView(viewModel: TodayViewModel(entryStore: MockEntryStore())).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge) }
