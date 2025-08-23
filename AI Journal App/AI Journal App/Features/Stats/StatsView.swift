//
//  StatsView.swift
//  AI Journal App
//
//  Stats with Swift Charts line for 7-day mood and KPI tiles
//

import SwiftUI
import Charts

struct StatsView: View {
    @StateObject private var viewModel: StatsViewModel
    
    init(viewModel: StatsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack { GradientBackground.peachCream.ignoresSafeArea(.container, edges: [.top, .bottom]) }
            .overlay(
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.l) {
                        TopBarCapsule(iconSystemName: "chart.line.uptrend.xyaxis", title: "Stats")
                        header
                        chartSection
                        kpiRow
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, AppSpacing.m)
                    .padding(.top, AppSpacing.m)
                    .appTheme()
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom) { Spacer().frame(height: AppSpacing.l) }
            )
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Your Insights").titleXL(weight: .bold).foregroundColor(AppColors.inkPrimary)
            Text("Your mood trends and wellness insights").body().foregroundColor(AppColors.inkSecondary)
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text("7-day Mood").titleM(weight: .semibold).foregroundColor(AppColors.inkPrimary)
            Chart(viewModel.last7Days) { point in
                LineMark(
                    x: .value("Day", point.date),
                    y: .value("Mood", point.moodScore)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(AppColors.lavender)
                AreaMark(
                    x: .value("Day", point.date),
                    y: .value("Mood", point.moodScore)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(Gradient(colors: [AppColors.lavender.opacity(0.35), .clear]))
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel() { if let doubleValue = value.as(Double.self) { Text("\(Int(doubleValue))").body() } }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel() {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.weekday(.abbreviated)).caption()
                        }
                    }
                }
            }
            .frame(height: 220)
            .background(
                RoundedRectangle(cornerRadius: AppRadii.large)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: AppRadii.large).stroke(Color.white.opacity(0.3), lineWidth: 1))
            )
        }
    }
    
    private var kpiRow: some View {
        HStack(spacing: AppSpacing.m) {
            KPITile(title: "Stress Level", value: "\(viewModel.stressPercent)%", subtitle: "Last 7 days", color: AppColors.sky)
            KPITile(title: "Sleep Hours", value: String(format: "%.1f", viewModel.avgSleepHours), subtitle: "Avg nightly", color: AppColors.mint)
        }
    }
}

private struct KPITile: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title).body().foregroundColor(AppColors.inkPrimary)
            Text(value).titleXL(weight: .bold).foregroundColor(AppColors.inkPrimary)
            Text(subtitle).caption().foregroundColor(AppColors.inkSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.m)
        .background(
            RoundedRectangle(cornerRadius: AppRadii.large)
                .fill(color.opacity(0.35))
                .overlay(RoundedRectangle(cornerRadius: AppRadii.large).stroke(Color.white.opacity(0.3), lineWidth: 1))
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
        )
    }
}

// MARK: - Previews

#Preview("Stats - Light") { StatsView(viewModel: StatsViewModel()) }
#Preview("Stats - Dark") { StatsView(viewModel: StatsViewModel()).preferredColorScheme(.dark) }
