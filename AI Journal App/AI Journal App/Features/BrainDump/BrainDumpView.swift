//
//  BrainDumpView.swift
//  AI Journal App
//
//  Distraction-free canvas for free-form thought capture
//

import SwiftUI

struct BrainDumpView: View {
    @StateObject private var viewModel: BrainDumpViewModel
    @FocusState private var isFocused: Bool
    @State private var selectedMood: MoodType? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showConfetti = false
    
    init(viewModel: BrainDumpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.clear
            ScrollViewReader { _ in
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            TextEffects.words("Brain Dump", font: AppTypography.titleXL, weight: .bold, color: AppColors.inkPrimary)
                            TextEffects.words("Let your thoughts flow freely", font: AppTypography.body, color: AppColors.inkSecondary)
                        }
                        .padding(.horizontal, AppSpacing.m)
                        
                        // Full-height glass card with editor
                        VStack(alignment: .leading, spacing: AppSpacing.m) {
                            PlaceholderTextEditor(
                                text: Binding(
                                    get: { viewModel.state.currentText },
                                    set: { viewModel.updateText($0) }
                                ),
                                placeholder: "What’s on your mind?",
                                font: AppTypography.body,
                                foreground: AppColors.inkPrimary,
                                placeholderColor: AppColors.inkSecondary
                            )
                            .focused($isFocused)
                            .frame(minHeight: UIScreen.main.bounds.height * 0.7)
                            .scrollDismissesKeyboard(.interactively)
                        }
                        .padding(AppSpacing.l)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadii.large)
                                .fill(.ultraThinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: AppRadii.large).fill(Color.white.opacity(0.12)))
                                .overlay(RoundedRectangle(cornerRadius: AppRadii.large).stroke(Color.white.opacity(0.30), lineWidth: 1))
                                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
                        )
                        .padding(.horizontal, AppSpacing.m)
                        
                        Spacer(minLength: AppSpacing.l)
                    }
                    .padding(.top, AppSpacing.m)
                }
            }
            if showConfetti { ConfettiView(duration: 1.2, colors: [AppColors.coral, AppColors.peach, AppColors.apricot]).transition(.opacity) }
        }
        .pastelBackground(.sunrise, animated: !reduceMotion)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack(spacing: AppSpacing.m) {
                    // Mood picker
                    HStack(spacing: AppSpacing.s) {
                        ForEach(MoodType.allCases, id: \.self) { mood in
                            Button {
                                selectedMood = mood
                                Haptics.light()
                            } label: {
                                MoodEmojiView(type: mood, size: .small, isSelected: selectedMood == mood)
                            }
                            .accessibilityLabel(mood.accessibilityLabel)
                            .frame(minWidth: 44, minHeight: 44)
                        }
                    }
                    Spacer()
                    // Mic button placeholder
                    Button { Haptics.light() } label: { Image(systemName: "mic.fill").font(.system(size: 16, weight: .semibold)) }
                        .frame(minWidth: 44, minHeight: 44)
                        .accessibilityLabel("Record voice note")
                    
                    Button("Save") {
                        Haptics.success()
                        viewModel.save()
                        withAnimation { showConfetti = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation { showConfetti = false } }
                    }
                    .disabled(!viewModel.canSave)
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(minHeight: 44)
                    .accessibilityLabel("Save entry")
                }
            }
        }
        .onChange(of: viewModel.state) { newState in
            if case .saved = newState { Haptics.success() }
        }
    }
}

#Preview("Brain Dump - Canvas") {
    BrainDumpView(viewModel: BrainDumpViewModel(entryStore: MockEntryStore()))
}
