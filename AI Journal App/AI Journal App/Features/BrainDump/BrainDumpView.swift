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
    @State private var showContent = false
    @State private var selectedMood: MoodType? = nil
    
    init(viewModel: BrainDumpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated background
                BrainDumpBackground()
                
                // Central glass card
                VStack(spacing: AppSpacing.l) {
                    VStack(alignment: .leading, spacing: AppSpacing.m) {
                        // Title
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Let your thoughts flow freely")
                                .titleL(weight: .semibold)
                                .foregroundColor(.white)
                            
                            if selectedMood != nil {
                                Text("Mood selected: \(selectedMood!.accessibilityLabel)")
                                    .caption()
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        // Mood row
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.m) {
                                ForEach(MoodType.allCases, id: \.self) { mood in
                                    Button {
                                        selectedMood = mood
                                        Haptics.light()
                                    } label: {
                                        MoodEmojiView(
                                            type: mood,
                                            size: .large,
                                            isSelected: selectedMood == mood
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel(mood.accessibilityLabel)
                                    .accessibilityAddTraits(selectedMood == mood ? .isSelected : [])
                                }
                            }
                        }
                        
                        // Text editor with placeholder overlay
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: Binding(
                                get: { viewModel.state.currentText },
                                set: { viewModel.updateText($0) }
                            ))
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.inkPrimary)
                            .focused($isTextEditorFocused)
                            .disabled(viewModel.isLoading)
                            .frame(minHeight: 180)
                            
                            if viewModel.state.currentText.isEmpty {
                                Text("Jot a quick note…")
                                    .body()
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.top, AppSpacing.s)
                                    .padding(.horizontal, AppSpacing.s)
                                    .allowsHitTesting(false)
                            }
                        }
                        .padding(AppSpacing.m)
                        .background(
                            // Glass style: blur + subtle white overlay + stroke
                            RoundedRectangle(cornerRadius: AppRadii.large)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadii.large)
                                        .fill(Color.white.opacity(0.12))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadii.large)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Primary CTA
                    Button("Save") {
                        viewModel.save()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.canSave)
                    .accessibilityLabel("Save brain dump entry")
                }
                .padding(AppSpacing.m)
            }
            .navigationBarHidden(true)
            .scaleEffect(showContent ? 1.0 : 0.95)
            .opacity(showContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.4), value: showContent)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.4).delay(0.1)) {
                    showContent = true
                }
            }
            .onDisappear { showContent = false }
            .onChange(of: viewModel.state) { newState in
                if case .saved = newState {
                    Haptics.light()
                }
            }
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: {
                if case .error = viewModel.state { return true }
                return false
            },
            set: { _ in }
        )) {
            Button("OK") { viewModel.dismissError() }
        } message: {
            if case .error(let message) = viewModel.state { Text(message) }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            if isTextEditorFocused { isTextEditorFocused = false }
        }
    }
}

// MARK: - Preview

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
