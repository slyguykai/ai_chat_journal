//
//  ConfettiView.swift
//  AI Journal App
//
//  Lightweight celebratory confetti using Timeline + Canvas
//

import SwiftUI

struct ConfettiView: View {
    let duration: TimeInterval
    let colors: [Color]
    @State private var startDate = Date()
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let t = timeline.date.timeIntervalSince(startDate)
                draw(context: &context, size: size, t: t)
            }
        }
        .allowsHitTesting(false)
        .onAppear { startDate = Date() }
    }
    
    private func draw(context: inout GraphicsContext, size: CGSize, t: TimeInterval) {
        guard t < duration else { return }
        let count = 80
        for i in 0..<count {
            let seed = Double(i)
            let progress = t / duration
            let x = size.width * CGFloat((seed.truncatingRemainder(dividingBy: 10)) / 10.0) + CGFloat(sin(seed) * 20)
            let fall = size.height * CGFloat(progress)
            let y = -20 + fall + CGFloat(cos(seed + progress * 6) * 8)
            let rect = CGRect(x: x, y: y, width: 4, height: 8)
            let path = Path(roundedRect: rect, cornerRadius: 1)
            let color = colors[Int(seed) % colors.count].opacity(1 - progress)
            context.withCGContext { cg in
                cg.translateBy(x: rect.midX, y: rect.midY)
                cg.rotate(by: CGFloat(progress * 2 * .pi))
                cg.translateBy(x: -rect.midX, y: -rect.midY)
            }
            context.fill(path, with: .color(color))
            context.stroke(path, with: .color(Color.white.opacity(0.2)))
        }
    }
}
