//
//  QuickAddSheet.swift
//  AI Journal App
//
//  Quick entry modal for adding journal entries with mood
//

import SwiftUI

/// Quick add sheet for creating journal entries
struct QuickAddSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var entryText: String = ""
    @State private var selectedMood: MoodType?
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppSpacing.l) {
                // Header
                VStack(spacing: AppSpacing.s) {
                    Text("Quick Entry")
                        .titleL(weight: .semibold)
                        .foregroundColor(AppColors.inkPrimary)
                    
                    Text("Capture your thoughts and mood")
                        .body()
                        .foregroundColor(AppColors.inkSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppSpacing.s)
                
                // Mood Selection
                VStack(alignment: .leading, spacing: AppSpacing.s) {
                    Text("How are you feeling?")
                        .body(weight: .medium)
                        .foregroundColor(AppColors.inkPrimary)
                    
                    MoodSelectionGrid(selectedMood: $selectedMood, size: .large)
                }
                
                // Text Input
                VStack(alignment: .leading, spacing: AppSpacing.s) {
                    Text("What's on your mind?")
                        .body(weight: .medium)
                        .foregroundColor(AppColors.inkPrimary)
                    
                    TextField("Start writing...", text: $entryText, axis: .vertical)
                        .textFieldStyle(QuickAddTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .lineLimit(5...10)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: AppSpacing.m) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .accessibilityLabel("Cancel entry")
                    
                    Button("Save Entry") {
                        saveEntry()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(entryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Save journal entry")
                }
            }
            .padding(AppSpacing.m)
            .background(AppColors.canvas)
            .navigationBarHidden(true)
        }
        .onAppear {
            // Auto-focus text field when sheet appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func saveEntry() {
        let trimmedText = entryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        // TODO: Save to data store
        print("Saving entry: \(trimmedText), mood: \(selectedMood?.rawValue ?? "none")")
        
        dismiss()
    }
}

// MARK: - Custom Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44) // Accessibility hit target
            .background(AppColors.coral)
            .cornerRadius(AppRadii.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.medium))
            .foregroundColor(AppColors.inkPrimary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44) // Accessibility hit target
            .background(AppColors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadii.medium)
                    .stroke(AppColors.divider, lineWidth: 1)
            )
            .cornerRadius(AppRadii.medium)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Custom Text Field Style

struct QuickAddTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(AppTypography.body)
            .foregroundColor(AppColors.inkPrimary)
            .padding(AppSpacing.m)
            .background(AppColors.surface)
            .cornerRadius(AppRadii.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadii.medium)
                    .stroke(AppColors.divider, lineWidth: 1)
            )
    }
}

// MARK: - Preview

#Preview("Quick Add Sheet - Light") {
    QuickAddSheet()
}

#Preview("Quick Add Sheet - Dark") {
    QuickAddSheet()
        .preferredColorScheme(.dark)
}

#Preview("Quick Add Sheet - Filled") {
    struct QuickAddPreview: View {
        @State private var showSheet = true
        
        var body: some View {
            Color.clear
                .sheet(isPresented: $showSheet) {
                    QuickAddSheet()
                }
        }
    }
    
    return QuickAddPreview()
}
