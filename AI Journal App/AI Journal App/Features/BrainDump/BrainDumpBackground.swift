//
//  BrainDumpBackground.swift
//  AI Journal App
//
//  Animated background for Brain Dump view with floating elements
//

import SwiftUI

/// Animated background view for Brain Dump with floating particles
struct BrainDumpBackground: View {
    @State private var animationOffset: CGFloat = 0
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            Color.clear
            // Animated overlay layer
            AnimatedParticleLayer(animationOffset: animationOffset, isVisible: isVisible)
        }
        .pastelBackground(.sunrise, animated: true)
        .onAppear {
            isVisible = true
            startAnimation()
        }
        .onDisappear {
            isVisible = false
        }
        .ignoresSafeArea()
    }
    
    private func startAnimation() {
        guard isVisible else { return }
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            animationOffset = 1000
        }
    }
}

/// Floating particle animation layer
private struct AnimatedParticleLayer: View {
    let animationOffset: CGFloat
    let isVisible: Bool
    
    var body: some View {
        if isVisible {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    drawFloatingElements(context: context, size: size, time: timeline.date.timeIntervalSince1970)
                }
            }
            .opacity(0.3)
        }
    }
    
    private func drawFloatingElements(context: GraphicsContext, size: CGSize, time: TimeInterval) {
        let particleCount = 8
        for i in 0..<particleCount {
            let phase = time * 0.5 + Double(i) * 0.8
            let x = size.width * 0.1 + (size.width * 0.8) * CGFloat(sin(phase * 0.3 + Double(i)))
            let y = size.height * 0.2 + (size.height * 0.6) * CGFloat(cos(phase * 0.2 + Double(i) * 0.7))
            let radius = 3 + 2 * CGFloat(sin(phase * 2))
            let opacity = 0.4 + 0.3 * sin(phase * 1.5)
            let color = i % 2 == 0 ? Color.white.opacity(opacity) : AppColors.apricot.opacity(opacity * 0.8)
            let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
            context.fill(Path(ellipseIn: rect), with: .color(color))
        }
    }
}

/// Floating gradient orbs animation layer (alternative approach)
private struct AnimatedGradientLayer: View {
    let animationOffset: CGFloat
    let isVisible: Bool
    @State private var orbPositions: [CGPoint] = []
    
    var body: some View {
        if isVisible {
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        FloatingOrb(index: index, size: geometry.size, animationOffset: animationOffset)
                    }
                }
            }
            .opacity(0.2)
        }
    }
}

/// Individual floating orb
private struct FloatingOrb: View {
    let index: Int
    let size: CGSize
    let animationOffset: CGFloat
    
    private var position: CGPoint {
        let phase = animationOffset * 0.01 + Double(index) * 2.0
        let x = size.width * 0.2 + (size.width * 0.6) * CGFloat(sin(phase * 0.3))
        let y = size.height * 0.3 + (size.height * 0.4) * CGFloat(cos(phase * 0.4))
        return CGPoint(x: x, y: y)
    }
    
    private var orbColor: Color {
        switch index {
        case 0: return AppColors.peach
        case 1: return AppColors.apricot
        default: return AppColors.blush
        }
    }
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [orbColor.opacity(0.6), orbColor.opacity(0.1), Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 40
                )
            )
            .frame(width: 80, height: 80)
            .position(position)
            .blur(radius: 20)
    }
}

// MARK: - Preview

#Preview("Brain Dump Background - Light") {
    BrainDumpBackground()
}
