//
//  ProgressTrailView.swift
//  AI Journal App
//
//  Visualizes gentle journaling goals (today ring / weekly steps)
//

import SwiftUI

struct ProgressTrailView: View {
    enum Mode {
        case today(completed: Bool)
        case weekly(current: Int, target: Int)
    }
    let mode: Mode
    
    @State private var animate = false
    
    var body: some View {
        switch mode {
        case .today(let completed):
            RingProgress(progress: completed ? (animate ? 1.0 : 0.0) : 0.0)
                .frame(width: 44, height: 44)
                .onAppear { withAnimation(.snappy(duration: 0.4)) { animate = true } }
                .accessibilityLabel("Today's journaling progress")
        case .weekly(let current, let target):
            HStack(spacing: 8) {
                ForEach(0..<target, id: \.self) { index in
                    Capsule(style: .continuous)
                        .fill(index < current ? AppColors.coral : AppColors.inkSecondary.opacity(0.2))
                        .frame(width: 18, height: 6)
                        .scaleEffect(y: animate ? 1 : 0.1, anchor: .bottom)
                        .animation(.snappy(duration: 0.28).delay(0.04 * Double(index)), value: animate)
                        .accessibilityHidden(true)
                }
            }
            .onAppear { animate = true }
            .accessibilityLabel("Weekly goal \(current) of \(target) days")
        }
    }
}

private struct RingProgress: View {
    let progress: CGFloat // 0...1
    
    var body: some View {
        ZStack {
            Circle().stroke(AppColors.inkSecondary.opacity(0.15), lineWidth: 6)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColors.coral, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.snappy(duration: 0.4), value: progress)
            Image(systemName: progress >= 1 ? "checkmark" : "pencil")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(progress >= 1 ? AppColors.coral : AppColors.inkSecondary)
        }
        .accessibilityHidden(true)
    }
}

#Preview("Today Ring") { ProgressTrailView(mode: .today(completed: true)) }
#Preview("Weekly Steps") { ProgressTrailView(mode: .weekly(current: 3, target: 7)) }
