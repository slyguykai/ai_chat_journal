//
//  KeyboardObserver.swift
//  AI Journal App
//
//  Publishes keyboard presentation state
//

import SwiftUI
import Combine

final class KeyboardObserver: ObservableObject {
    @Published private(set) var isKeyboardPresented: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
        Publishers.Merge(willShow, willHide)
            .receive(on: RunLoop.main)
            .assign(to: &$isKeyboardPresented)
    }
}
