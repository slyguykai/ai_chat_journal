//
//  TextEffects.swift
//  AI Journal App
//
//  Tasteful text reveal effects for hero copy (word- and line-based)
//

import SwiftUI

struct WordRevealText: View {
    let text: String
    let font: Font
    let weight: Font.Weight
    let color: Color
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    
    var body: some View {
        let words = text.split(separator: " ").map(String.init)
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                Text(word)
                    .font(font)
                    .fontWeight(weight)
                    .foregroundColor(color)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared || reduceMotion ? 0 : 8)
                    .animation(
                        reduceMotion ? .easeIn(duration: 0.15) : .snappy(duration: 0.28).delay(0.05 * Double(index)),
                        value: appeared
                    )
            }
        }
        .onAppear { appeared = true }
    }
}

struct LineRevealText: View {
    let text: String
    let font: Font
    let weight: Font.Weight
    let color: Color
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    
    var body: some View {
        let lines = text.split(separator: "\n").map(String.init)
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                Text(line)
                    .font(font)
                    .fontWeight(weight)
                    .foregroundColor(color)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared || reduceMotion ? 0 : 8)
                    .animation(
                        reduceMotion ? .easeIn(duration: 0.15) : .snappy(duration: 0.28).delay(0.08 * Double(index)),
                        value: appeared
                    )
            }
        }
        .onAppear { appeared = true }
    }
}

enum TextEffects {
    static func words(_ text: String, font: Font, weight: Font.Weight = .regular, color: Color) -> some View {
        WordRevealText(text: text, font: font, weight: weight, color: color)
    }
    static func lines(_ text: String, font: Font, weight: Font.Weight = .regular, color: Color) -> some View {
        LineRevealText(text: text, font: font, weight: weight, color: color)
    }
}
