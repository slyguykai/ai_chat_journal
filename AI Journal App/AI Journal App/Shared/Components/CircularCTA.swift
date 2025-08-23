//
//  CircularCTA.swift
//  AI Journal App
//
//  Reusable circular call-to-action button with gradient and shadow
//

import SwiftUI

/// Size variants for circular CTA buttons
enum CircularCTASize {
    case medium     // 48pt
    case large      // 64pt
    case extraLarge // 80pt
    
    var dimension: CGFloat {
        switch self {
        case .medium:
            return 48
        case .large:
            return 64
        case .extraLarge:
            return 80
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .medium:
            return 20
        case .large:
            return 24
        case .extraLarge:
            return 28
        }
    }
}

/// Reusable circular call-to-action button
struct CircularCTA: View {
    let icon: String
    let size: CircularCTASize
    let action: () -> Void
    var accessibilityLabel: String = ""
    var accessibilityHint: String = ""
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            Haptics.medium()
            action()
        }) {
            ZStack {
                // Background gradient with shadow
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.peach, AppColors.coral]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size.dimension, height: size.dimension)
                    .shadow(
                        color: AppColors.coral.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                
                // Icon
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .frame(width: max(44, size.dimension), height: max(44, size.dimension)) // Ensure 44pt minimum hit target
    }
}

// MARK: - Preview

#Preview("Circular CTA Sizes - Light") {
    VStack(spacing: AppSpacing.l) {
        Text("Circular CTA Buttons")
            .titleL(weight: .bold)
            .foregroundColor(AppColors.inkPrimary)
        
        VStack(spacing: AppSpacing.m) {
            HStack(spacing: AppSpacing.m) {
                Text("Medium (48pt)")
                    .body()
                    .foregroundColor(AppColors.inkSecondary)
                Spacer()
                CircularCTA(
                    icon: "plus",
                    size: .medium,
                    action: {},
                    accessibilityLabel: "Add entry",
                    accessibilityHint: "Opens the brain dump editor"
                )
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Large (64pt)")
                    .body()
                    .foregroundColor(AppColors.inkSecondary)
                Spacer()
                CircularCTA(
                    icon: "plus.circle.fill",
                    size: .large,
                    action: {},
                    accessibilityLabel: "Add entry",
                    accessibilityHint: "Opens the brain dump editor"
                )
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Extra Large (80pt)")
                    .body()
                    .foregroundColor(AppColors.inkSecondary)
                Spacer()
                CircularCTA(
                    icon: "sparkles",
                    size: .extraLarge,
                    action: {},
                    accessibilityLabel: "Inspire me",
                    accessibilityHint: "Opens inspiration prompts"
                )
            }
        }
        
        Spacer()
        
        Text("Tap to test haptic feedback")
            .caption()
            .foregroundColor(AppColors.inkSecondary)
    }
    .padding(AppSpacing.m)
    .background(AppColors.canvas)
}

#Preview("Circular CTA Sizes - Dark") {
    VStack(spacing: AppSpacing.l) {
        Text("Circular CTA Buttons")
            .titleL(weight: .bold)
            .foregroundColor(.white)
        
        VStack(spacing: AppSpacing.m) {
            HStack(spacing: AppSpacing.m) {
                Text("Medium (48pt)")
                    .body()
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                CircularCTA(
                    icon: "plus",
                    size: .medium,
                    action: {},
                    accessibilityLabel: "Add entry",
                    accessibilityHint: "Opens the brain dump editor"
                )
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Large (64pt)")
                    .body()
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                CircularCTA(
                    icon: "plus.circle.fill",
                    size: .large,
                    action: {},
                    accessibilityLabel: "Add entry",
                    accessibilityHint: "Opens the brain dump editor"
                )
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Extra Large (80pt)")
                    .body()
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                CircularCTA(
                    icon: "sparkles",
                    size: .extraLarge,
                    action: {},
                    accessibilityLabel: "Inspire me",
                    accessibilityHint: "Opens inspiration prompts"
                )
            }
        }
        
        Spacer()
        
        Text("Tap to test haptic feedback")
            .caption()
            .foregroundColor(.white.opacity(0.7))
    }
    .padding(AppSpacing.m)
    .background(.black)
    .preferredColorScheme(.dark)
}
