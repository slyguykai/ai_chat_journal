//
//  CardPressModifier.swift
//  AI Journal App
//
//  Reusable micro-interaction for pressable cards.
//

import SwiftUI

struct CardPressModifier: ViewModifier {
    @GestureState private var isPressing: Bool = false
    let onTap: (() -> Void)?
    
    func body(content: Content) -> some View {
        // Use a short long-press with a small max distance so vertical drags (scroll) win
        let press = LongPressGesture(minimumDuration: 0.05, maximumDistance: 8)
            .updating($isPressing) { _, state, _ in
                if state == false { Haptics.light() }
                state = true
            }
            .onEnded { _ in onTap?() }
        
        return content
            .scaleEffect(isPressing ? 0.98 : 1.0)
            .offset(y: isPressing ? 1 : 0)
            .animation(.snappy, value: isPressing)
            // Attach simultaneously so ScrollView can still receive pan gestures
            .simultaneousGesture(press)
    }
}

extension View {
    func cardPress(onTap: (() -> Void)? = nil) -> some View {
        modifier(CardPressModifier(onTap: onTap))
    }
}

#Preview("Card Press") {
    SurfaceCard {
        Text("Press me").titleM(weight: .semibold)
    }
    .cardPress()
    .padding()
    .background(AppColors.background)
}
