//
//  AppContainer.swift
//  AI Journal App
//
//  Dependency injection container for the app
//

import Foundation

/// Main dependency container providing services to views
@MainActor
class AppContainer: ObservableObject {
    // MARK: - Services
    
    let entryStore: any EntryStore
    
    // MARK: - Initialization
    
    init(entryStore: (any EntryStore)? = nil) {
        self.entryStore = entryStore ?? MockEntryStore()
    }
    
    // MARK: - Factory Methods
    
    func makeEntryListViewModel() -> EntryListViewModel {
        EntryListViewModel(entryStore: entryStore)
    }
}
