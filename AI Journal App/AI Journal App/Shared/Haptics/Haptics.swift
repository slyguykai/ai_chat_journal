//
//  Haptics.swift
//  AI Journal App
//
//  Haptic feedback wrapper for consistent user experience
//

import UIKit

/// Haptic feedback manager for consistent tactile responses
struct Haptics {
    private static var enabled: Bool {
        if UserDefaults.standard.object(forKey: "settings.hapticsEnabled") == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: "settings.hapticsEnabled")
    }
    
    // MARK: - Impact Feedback
    
    /// Light impact feedback for subtle interactions
    static func light() {
        guard enabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Medium impact feedback for standard interactions
    static func medium() {
        guard enabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Heavy impact feedback for significant interactions
    static func heavy() {
        guard enabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    // MARK: - Selection Feedback
    
    /// Selection feedback for UI selections and changes
    static func selection() {
        guard enabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // MARK: - Notification Feedback
    
    /// Success notification feedback
    static func success() {
        guard enabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Warning notification feedback
    static func warning() {
        guard enabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Error notification feedback
    static func error() {
        guard enabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    // MARK: - Prepared Feedback
    
    /// Prepare haptic engine for immediate feedback
    /// Call before interactions that need responsive haptics
    static func prepare() {
        guard enabled else { return }
        let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactGenerator.prepare()
        
        let selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator.prepare()
        
        let notificationGenerator = UINotificationFeedbackGenerator()
        notificationGenerator.prepare()
    }
}
