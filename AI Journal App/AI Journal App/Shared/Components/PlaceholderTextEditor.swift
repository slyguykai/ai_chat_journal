//
//  PlaceholderTextEditor.swift
//  AI Journal App
//
//  Multiline TextEditor with placeholder overlay
//

import SwiftUI

struct PlaceholderTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let font: Font
    let foreground: Color
    let placeholderColor: Color
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(font)
                .foregroundColor(foreground)
                .focused($isFocused)
                .padding(.horizontal, -4) // align placeholder
            if text.isEmpty {
                Text(placeholder)
                    .font(font)
                    .foregroundColor(placeholderColor)
                    .padding(.top, AppSpacing.s)
                    .padding(.leading, 2)
                    .allowsHitTesting(false)
            }
        }
    }
}
