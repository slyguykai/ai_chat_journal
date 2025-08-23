//
//  BrainDumpView.swift
//  AI Journal App
//
//  Brain dump view for free-form thought capture
//

import SwiftUI

/// Brain dump view for capturing free-form thoughts
struct BrainDumpView: View {
    @StateObject private var viewModel: BrainDumpViewModel
    @FocusState private var isTextEditorFocused: Bool
    @State private var showHeroCard = false
    @State private var selectedMood: MoodType? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    init(viewModel: BrainDumpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BrainDumpBackground()
                .ignoresSafeArea(.container, edges: [.top, .bottom])
            
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    TopBarCapsule(iconSystemName: "brain.head.profile", title: "Brain Dump")
                    
                    // Mood row (even distribution)
                    HStack(spacing: 0) {
                        ForEach(MoodType.allCases, id: \.self) { mood in
                            Button {
                                selectedMood = mood
                                Haptics.light()
                            } label: {
                                MoodEmojiView(type: mood, size: .large, isSelected: selectedMood == mood)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .accessibilityLabel(mood.accessibilityLabel)
                            .accessibilityAddTraits(selectedMood == mood ? .isSelected : [])
                        }
                    }
                    
                    // Text editor card with higher contrast (hero card)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { viewModel.state.currentText },
                            set: { viewModel.updateText($0) }
                        ))
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.inkPrimary)
                        .focused($isTextEditorFocused)
                        .disabled(viewModel.isLoading)
                        .frame(minHeight: 260)
                        
                        if viewModel.state.currentText.isEmpty {
                            Text("Let your thoughts flow freely.")
                                .body()
                                .foregroundColor(AppColors.inkSecondary)
                                .padding(.top, AppSpacing.s)
                                .padding(.horizontal, AppSpacing.s)
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(AppSpacing.m)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadii.large)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadii.large)
                                    .fill(Color.white.opacity(0.18))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadii.large)
                                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                    )
                    .scaleEffect(reduceMotion ? 1.0 : (showHeroCard ? 1.0 : 0.85))
                    .opacity(reduceMotion ? 1.0 : (showHeroCard ? 1.0 : 0.0))
                    
                    Button("Save") {
                        Haptics.light()
                        viewModel.save()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.canSave)
                    .accessibilityLabel("Save brain dump entry")
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
                .padding(.bottom, AppSpacing.l)
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .bottom) { Spacer().frame(height: AppSpacing.l) }
        }
        .onAppear {
            if reduceMotion {
                showHeroCard = true
            } else {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.9, blendDuration: 0.1)) {
                    showHeroCard = true
                }
            }
        }
        .onDisappear { showHeroCard = false }
        .onChange(of: viewModel.state) { newState in
            if case .saved = newState { Haptics.success() }
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { if case .error = viewModel.state { return true }; return false },
            set: { _ in }
        )) { Button("OK") { viewModel.dismissError() } } message: {
            if case .error(let message) = viewModel.state { Text(message) }
        }
        .onTapGesture { if isTextEditorFocused { isTextEditorFocused = false } }
    }
}

// MARK: - Previews remain unchanged

#Preview("Brain Dump - Idle") {
    BrainDumpView(
        viewModel: BrainDumpViewModel(entryStore: MockEntryStore())
    )
}

#Preview("Brain Dump - Editing") {
    struct EditingPreview: View {
        var body: some View {
            BrainDumpView(
                viewModel: {
                    let vm = BrainDumpViewModel(entryStore: MockEntryStore())
                    vm.startEditing()
                    vm.updateText("This is a sample brain dump entry with some text to show how it looks when editing...")
                    return vm
                }()
            )
        }
    }
    
    return EditingPreview()
}

#Preview("Brain Dump - Dark Mode") {
    BrainDumpView(
        viewModel: BrainDumpViewModel(entryStore: MockEntryStore())
    )
    .preferredColorScheme(.dark)
}
