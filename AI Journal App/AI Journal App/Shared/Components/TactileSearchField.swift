//
//  TactileSearchField.swift
//  AI Journal App
//
//  Indented neomorphic search field with SF Symbol leading icon.
//

import SwiftUI

struct TactileSearchField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: AppSpacing.s) {
            Image(system: .magnifyingglass)
                .foregroundColor(AppColors.inkSecondary)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .foregroundColor(AppColors.inkPrimary)
                .font(AppTypography.body)
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, AppSpacing.s)
        .background(AppColors.background)
        .neumorphIndented(cornerRadius: AppRadii.large)
        .accessibilityLabel("Search entries")
    }
}

#Preview("TactileSearchField") {
    TactileSearchField(text: .constant(""), placeholder: "Search entries")
        .padding(24)
        .background(AppColors.background)
}

