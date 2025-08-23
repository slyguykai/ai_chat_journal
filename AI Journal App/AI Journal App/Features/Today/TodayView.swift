//
//  TodayView.swift
//  AI Journal App
//
//  Polished Today screen with greeting, streak chip, and prompt card
//

import SwiftUI

struct TodayView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        ZStack {
            GradientBackground.peachCream
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    TopBarCapsule(iconSystemName: "house", title: "Today")
                    header
                    promptCard
                    Spacer(minLength: AppSpacing.l)
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
            }
            .scrollIndicators(.hidden)
        }
        .appTheme()
    }
    
    // MARK: - Sections
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(greeting())
                .titleXL(weight: .bold)
                .foregroundColor(AppColors.inkPrimary)
            Text("Keep the momentum going")
                .body()
                .foregroundColor(AppColors.inkSecondary)
        }
    }
    
    private var promptCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text("Mini Prompt")
                .body(weight: .semibold)
                .foregroundColor(AppColors.inkPrimary)
            Text("What made you smile today?")
                .titleM(weight: .medium)
                .foregroundColor(AppColors.inkPrimary)
            HStack(spacing: AppSpacing.m) {
                Button("Reflect") { Haptics.light() }
                    .buttonStyle(PrimaryButtonStyle())
                    .accessibilityLabel("Reflect on this prompt")
                Button("Try later") { Haptics.light() }
                    .buttonStyle(SecondaryButtonStyle())
                    .accessibilityLabel("Save prompt for later")
            }
        }
        .padding(AppSpacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppRadii.medium)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadii.medium)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
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

#Preview("Today - Light") { TodayView() }
#Preview("Today - Dark") { TodayView().preferredColorScheme(.dark) }
#Preview("Today - Large Type") { TodayView().environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge) }
