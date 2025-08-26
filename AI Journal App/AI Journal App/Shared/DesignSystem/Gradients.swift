//
//  Gradients.swift
//  AI Journal App
//
//  Unified gradient presets and pastel background modifier
//

import SwiftUI

enum AppGradient: CaseIterable {
    case sunrise
    case blushLavender
    case peachCream
}

private struct PastelBackground: View {
    let preset: AppGradient
    let animated: Bool
    
    var body: some View {
        ZStack {
            radial(for: preset)
                .ignoresSafeArea()
            if animated {
                animatedLayer(for: preset)
                    .ignoresSafeArea()
            }
            noiseOverlay
                .ignoresSafeArea()
        }
    }
    
    private func radial(for preset: AppGradient) -> RadialGradient {
        let colors: [Color]
        switch preset {
        case .sunrise:
            colors = [Color(hex: "FFE0B2"), Color(hex: "FFB07B"), Color(hex: "FF8A65")]
        case .blushLavender:
            colors = [Color(hex: "FAD4E6"), Color(hex: "E6D2FF")]
        case .peachCream:
            colors = [Color(hex: "FFEAD6"), Color(hex: "FFD3A1")]
        }
        return RadialGradient(
            gradient: Gradient(colors: [colors.first!.opacity(0.95), colors.last!.opacity(0.7), Color.clear]),
            center: .center,
            startRadius: 0,
            endRadius: 900
        )
    }
    
    @ViewBuilder
    private func animatedLayer(for preset: AppGradient) -> some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSince1970
            let phase = CGFloat(sin(t / 6.0))
            let offset = CGSize(width: 40 * phase, height: -40 * phase)
            radial(for: preset)
                .opacity(0.25)
                .offset(offset)
                .blur(radius: 12)
                .allowsHitTesting(false)
        }
    }
    
    private var noiseOverlay: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.black.opacity(0.02), Color.white.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .blendMode(.overlay)
            .opacity(0.06)
            .allowsHitTesting(false)
    }
}

private struct PastelBackgroundModifier: ViewModifier {
    let preset: AppGradient
    let animated: Bool
    func body(content: Content) -> some View {
        ZStack {
            PastelBackground(preset: preset, animated: animated)
            content
        }
    }
}

extension View {
    func pastelBackground(_ preset: AppGradient, animated: Bool = true) -> some View {
        modifier(PastelBackgroundModifier(preset: preset, animated: animated))
    }
}
