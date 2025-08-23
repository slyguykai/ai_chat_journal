//
//  MoodEmojiView.swift
//  AI Journal App
//
//  Reusable mood emoji component with accessibility support
//

import SwiftUI

/// Mood types supported by the emoji system
enum MoodType: String, CaseIterable, Codable {
    case happy = "happy"
    case sad = "sad"
    case neutral = "neutral"
    case excited = "excited"
    case love = "love"
    
    /// Human-readable description for accessibility
    var accessibilityLabel: String {
        switch self {
        case .happy:
            return "Happy mood"
        case .sad:
            return "Sad mood"
        case .neutral:
            return "Neutral mood"
        case .excited:
            return "Excited mood"
        case .love:
            return "Love mood"
        }
    }
    
    /// Mood score for analytics (1-10 scale)
    var moodScore: Int {
        switch self {
        case .sad:
            return 3
        case .neutral:
            return 5
        case .happy:
            return 8
        case .excited:
            return 9
        case .love:
            return 10
        }
    }
}

/// Size variations for the mood emoji
enum MoodEmojiSize {
    case small      // 24pt
    case medium     // 32pt  
    case large      // 44pt
    
    var dimension: CGFloat {
        switch self {
        case .small:
            return 24
        case .medium:
            return 32
        case .large:
            return 44
        }
    }
}

/// Mood emoji view component with accessibility support
struct MoodEmojiView: View {
    let type: MoodType
    let size: MoodEmojiSize
    var isSelected: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(strokeColor, lineWidth: strokeWidth)
                .fill(fillColor)
                .frame(width: size.dimension, height: size.dimension)
            
            emojiPath
                .foregroundColor(AppColors.inkPrimary)
        }
        .accessibilityLabel(type.accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select this mood")
    }
    
    // MARK: - Private Properties
    
    private var strokeColor: Color {
        isSelected ? AppColors.coral : AppColors.divider
    }
    
    private var fillColor: Color {
        isSelected ? AppColors.coral.opacity(0.1) : AppColors.surface
    }
    
    private var strokeWidth: CGFloat {
        isSelected ? 2 : 1
    }
    
    @ViewBuilder
    private var emojiPath: some View {
        let iconSize = size.dimension * 0.6
        
        switch type {
        case .happy:
            Image(systemName: "face.smiling")
                .font(.system(size: iconSize * 0.7))
        case .sad:
            Image(systemName: "face.dashed")
                .font(.system(size: iconSize * 0.7))
        case .neutral:
            Image(systemName: "minus")
                .font(.system(size: iconSize * 0.5, weight: .medium))
        case .excited:
            Image(systemName: "sparkles")
                .font(.system(size: iconSize * 0.6))
        case .love:
            Image(systemName: "heart.fill")
                .font(.system(size: iconSize * 0.6))
                .foregroundColor(AppColors.coral)
        }
    }
}

// MARK: - Selectable Mood Grid

/// Grid of selectable mood emojis
struct MoodSelectionGrid: View {
    @Binding var selectedMood: MoodType?
    let size: MoodEmojiSize
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.s) {
            ForEach(MoodType.allCases, id: \.self) { mood in
                Button {
                    selectedMood = mood
                } label: {
                    MoodEmojiView(
                        type: mood,
                        size: size,
                        isSelected: selectedMood == mood
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: AppSpacing.s), count: 5)
    }
}

// MARK: - Preview

#Preview("Mood Emoji Sizes - Light") {
    VStack(spacing: AppSpacing.l) {
        Text("Mood Emoji Sizes")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(AppColors.inkPrimary)
        
        VStack(spacing: AppSpacing.m) {
            HStack(spacing: AppSpacing.m) {
                Text("Small (24pt)")
                    .font(.caption)
                    .foregroundColor(AppColors.inkSecondary)
                Spacer()
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MoodType.happy, .neutral, .sad], id: \.self) { mood in
                        MoodEmojiView(type: mood, size: .small)
                    }
                }
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Medium (32pt)")
                    .font(.caption)
                    .foregroundColor(AppColors.inkSecondary)
                Spacer()
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MoodType.happy, .neutral, .sad], id: \.self) { mood in
                        MoodEmojiView(type: mood, size: .medium)
                    }
                }
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Large (44pt)")
                    .font(.caption)
                    .foregroundColor(AppColors.inkSecondary)
                Spacer()
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MoodType.happy, .neutral, .sad], id: \.self) { mood in
                        MoodEmojiView(type: mood, size: .large, isSelected: mood == .happy)
                    }
                }
            }
        }
        
        Text("Selection Grid")
            .font(.headline)
            .foregroundColor(AppColors.inkPrimary)
            .padding(.top, AppSpacing.l)
        
        MoodSelectionGrid(selectedMood: .constant(.happy), size: .medium)
    }
    .padding(AppSpacing.m)
    .background(AppColors.canvas)
}

#Preview("Mood Emoji Sizes - Dark") {
    VStack(spacing: AppSpacing.l) {
        Text("Mood Emoji Sizes")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        
        VStack(spacing: AppSpacing.m) {
            HStack(spacing: AppSpacing.m) {
                Text("Small (24pt)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MoodType.happy, .neutral, .sad], id: \.self) { mood in
                        MoodEmojiView(type: mood, size: .small)
                    }
                }
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Medium (32pt)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MoodType.happy, .neutral, .sad], id: \.self) { mood in
                        MoodEmojiView(type: mood, size: .medium)
                    }
                }
            }
            
            HStack(spacing: AppSpacing.m) {
                Text("Large (44pt)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                HStack(spacing: AppSpacing.xs) {
                    ForEach([MoodType.happy, .neutral, .sad], id: \.self) { mood in
                        MoodEmojiView(type: mood, size: .large, isSelected: mood == .happy)
                    }
                }
            }
        }
        
        Text("Selection Grid")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, AppSpacing.l)
        
        MoodSelectionGrid(selectedMood: .constant(.happy), size: .medium)
    }
    .padding(AppSpacing.m)
    .background(Color.black)
    .preferredColorScheme(.dark)
}
