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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showConfetti = false
    @State private var controlsVisible = false
    
    init(viewModel: BrainDumpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BrainDumpBackground()
            ScrollViewReader { _ in
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        // Indented "writing well" editor surface
                        VStack(alignment: .leading, spacing: AppSpacing.m) {
                            PlaceholderTextEditor(
                                text: Binding(
                                    get: { viewModel.state.currentText },
                                    set: { viewModel.updateText($0) }
                                ),
                                placeholder: "What’s on your mind?",
                                font: AppTypography.body,
                                foreground: AppColors.inkPrimary,
                                placeholderColor: AppColors.inkSecondary,
                                tint: AppColors.accent
                            )
                            .focused($isFocused)
                            .frame(minHeight: UIScreen.main.bounds.height * 0.7)
                            .scrollDismissesKeyboard(.interactively)
                        }
                        .padding(AppSpacing.l)
                        .background(AppColors.background)
                        .neumorphIndented(cornerRadius: AppRadii.large, distance: 6, blur: 10)
                        .padding(.horizontal, AppSpacing.m)
                        
                        Spacer(minLength: AppSpacing.l)
                    }
                    .padding(.top, AppSpacing.m)
                }
            }
            if showConfetti { ConfettiView(duration: 1.2, colors: [AppColors.accent, AppColors.neoHighlight, AppColors.neoShadow]).transition(.opacity) }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack(spacing: AppSpacing.m) {
                    // Mood picker
                    HStack(spacing: AppSpacing.s) {
                        ForEach(MoodType.allCases, id: \.self) { mood in
                            Button {
                                viewModel.selectedMood = mood
                                Haptics.light()
                            } label: {
                                MoodEmojiView(type: mood, size: .small, isSelected: viewModel.selectedMood == mood)
                            }
                            .buttonStyle(TactileIconButtonStyle())
                            .accessibilityLabel(mood.accessibilityLabel)
                            .accessibilityIdentifier("mood_\(mood.rawValue)_button")
                            .frame(minWidth: 44, minHeight: 44)
                        }
                    }
                    Spacer()
                    // Mic dictation toggle
                    Button {
                        Haptics.light()
                        viewModel.toggleDictation()
                    } label: {
                        Image(systemName: viewModel.isDictating ? "mic.circle.fill" : "mic.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(viewModel.isDictating ? AppColors.accent : AppColors.inkPrimary)
                    }
                    .buttonStyle(TactileIconButtonStyle())
                    .accessibilityIdentifier("mic_button")
                        .frame(minWidth: 44, minHeight: 44)
                        .accessibilityLabel("Record voice note")
                    
                    Button("Save") {
                        Haptics.success()
                        viewModel.save()
                        withAnimation { showConfetti = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation { showConfetti = false } }
                    }
                    .disabled(!viewModel.canSave)
                    .buttonStyle(TactilePrimaryButtonStyle())
                    .frame(minHeight: 44)
                    .accessibilityLabel("Save entry")
                    .accessibilityIdentifier("save_entry_button")
                }
                .opacity(controlsVisible ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.9), value: controlsVisible)
                .disabled(!controlsVisible)
            }
        }
        .onChange(of: viewModel.state) { _, newState in
            if case .saved = newState { Haptics.success() }
            controlsVisible = !newState.currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        .onAppear {
            viewModel.startEditing()
            isFocused = true
            controlsVisible = !viewModel.state.currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

#Preview("Brain Dump - Canvas") {
    BrainDumpView(viewModel: BrainDumpViewModel(entryStore: MockEntryStore()))
}
