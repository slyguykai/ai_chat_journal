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
    
    init(viewModel: BrainDumpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated background
                BrainDumpBackground()
                
                VStack(spacing: AppSpacing.l) {
                    // Header
                    VStack(spacing: AppSpacing.s) {
                        Text("Brain Dump")
                            .titleL(weight: .semibold)
                            .foregroundColor(.white)
                        
                        Text("Let your thoughts flow freely")
                            .body()
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, AppSpacing.s)
                
                // Text Editor
                VStack(alignment: .leading, spacing: AppSpacing.s) {
                    if viewModel.state.isEditing {
                        HStack {
                            Text("What's on your mind?")
                                .body(weight: .medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(viewModel.characterCount) characters")
                                .caption()
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { viewModel.state.currentText },
                            set: { viewModel.updateText($0) }
                        ))
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.inkPrimary)
                        .focused($isTextEditorFocused)
                        .disabled(viewModel.isLoading)
                        
                        if !viewModel.state.isEditing {
                            VStack(spacing: AppSpacing.s) {
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 48))
                                    .foregroundColor(AppColors.inkSecondary.opacity(0.6))
                                
                                                            Text("Tap to start brain dumping")
                                .body()
                                .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.startEditing()
                                isTextEditorFocused = true
                            }
                        }
                    }
                    .frame(minHeight: 200)
                    .padding(AppSpacing.m)
                    .background(AppColors.surface)
                    .cornerRadius(AppRadii.large)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadii.large)
                            .stroke(AppColors.divider, lineWidth: 1)
                    )
                }
                
                // Action Buttons
                if viewModel.state.isEditing {
                    HStack(spacing: AppSpacing.m) {
                        Button("Clear") {
                            viewModel.reset()
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .accessibilityLabel("Clear text")
                        
                        Button("Save Entry") {
                            viewModel.save()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!viewModel.canSave)
                        .accessibilityLabel("Save brain dump entry")
                    }
                }
                
                // Status Messages
                if case .saved = viewModel.state {
                    HStack(spacing: AppSpacing.s) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.mint)
                        
                        Text("Entry saved successfully!")
                            .body(weight: .medium)
                            .foregroundColor(AppColors.mint)
                    }
                    .padding(AppSpacing.m)
                    .background(AppColors.mint.opacity(0.1))
                    .cornerRadius(AppRadii.medium)
                }
                
                if viewModel.isLoading {
                    HStack(spacing: AppSpacing.s) {
                        ProgressView()
                            .scaleEffect(0.8)
                        
                        Text("Saving...")
                            .body()
                            .foregroundColor(AppColors.inkSecondary)
                    }
                }
                
                    Spacer()
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
            .onDisappear {
                showContent = false
            }
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: {
                if case .error = viewModel.state { return true }
                return false
            },
            set: { _ in }
        )) {
            Button("OK") {
                viewModel.dismissError()
            }
        } message: {
            if case .error(let message) = viewModel.state {
                Text(message)
            }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            if isTextEditorFocused {
                isTextEditorFocused = false
            }
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
