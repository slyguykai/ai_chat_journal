//
//  Spacing.swift
//  AI Journal App
//
//  Design System Spacing Tokens
//

import SwiftUI

/// Consistent spacing tokens based on 8pt grid system
struct AppSpacing {
    
    /// Extra small spacing: 8pt
    static let xs: CGFloat = 8
    
    /// Small spacing: 12pt
    static let s: CGFloat = 12
    
    /// Medium spacing: 16pt (base unit)
    static let m: CGFloat = 16
    
    /// Large spacing: 24pt
    static let l: CGFloat = 24
    
    /// Extra large spacing: 32pt
    static let xl: CGFloat = 32
}

// MARK: - Preview

#Preview("Spacing Tokens - Light") {
    VStack(alignment: .leading, spacing: 12) {
        Text("Spacing Scale")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
        
        SpacingRow(name: "XS", value: AppSpacing.xs)
        SpacingRow(name: "S", value: AppSpacing.s)
        SpacingRow(name: "M", value: AppSpacing.m)
        SpacingRow(name: "L", value: AppSpacing.l)
        SpacingRow(name: "XL", value: AppSpacing.xl)
        
        Text("Stack Example")
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.top, 24)
        
        VStack(spacing: 16) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.orange)
                    .frame(height: 40)
            }
        }
    }
    .padding(16)
    .background(Color(red: 1.0, green: 0.97, blue: 0.95))
}

#Preview("Spacing Tokens - Dark") {
    VStack(alignment: .leading, spacing: 12) {
        Text("Spacing Scale")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        
        SpacingRow(name: "XS", value: AppSpacing.xs, isDark: true)
        SpacingRow(name: "S", value: AppSpacing.s, isDark: true)
        SpacingRow(name: "M", value: AppSpacing.m, isDark: true)
        SpacingRow(name: "L", value: AppSpacing.l, isDark: true)
        SpacingRow(name: "XL", value: AppSpacing.xl, isDark: true)
        
        Text("Stack Example")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 24)
        
        VStack(spacing: 16) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.orange)
                    .frame(height: 40)
            }
        }
    }
    .padding(16)
    .background(Color.black)
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helper

private struct SpacingRow: View {
    let name: String
    let value: CGFloat
    var isDark: Bool = false
    
    var body: some View {
        HStack {
            Text("\(name):")
                .fontWeight(.medium)
                .foregroundColor(isDark ? .white : .primary)
                .frame(width: 30, alignment: .leading)
            
            Text("\(Int(value))pt")
                .foregroundColor(isDark ? .white.opacity(0.7) : .secondary)
                .frame(width: 50, alignment: .leading)
            
            Rectangle()
                .fill(.orange)
                .frame(width: value, height: 4)
            
            Spacer()
        }
    }
}


