//
//  AppContainer.swift
//  AI Journal App
//
//  Dependency injection container for the app
//

import Foundation
import SwiftData

/// Main dependency container providing services to views
@MainActor
class AppContainer: ObservableObject {
    // MARK: - Services
    
    let entryStore: any EntryStore
    let modelContainer: ModelContainer?
    
    // MARK: - Initialization
    
    init(useSwiftData: Bool = true, entryStore: (any EntryStore)? = nil) {
        if let customStore = entryStore {
            self.entryStore = customStore
            self.modelContainer = nil
        } else if useSwiftData {
            do {
                let container = try ModelContainer(for: Entry.self)
                self.modelContainer = container
                self.entryStore = SwiftDataEntryStore(modelContext: container.mainContext)
            } catch {
                print("Failed to create SwiftData container: \(error)")
                self.modelContainer = nil
                self.entryStore = MockEntryStore()
            }
        } else {
            self.entryStore = MockEntryStore()
            self.modelContainer = nil
        }
    }
    
    /// Create container with in-memory SwiftData for testing
    static func inMemoryContainer() throws -> AppContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)
        let store = SwiftDataEntryStore(modelContext: container.mainContext)
        return AppContainer(entryStore: store)
    }
    
    // MARK: - Factory Methods
    
    func makeEntryListViewModel() -> EntryListViewModel {
        EntryListViewModel(entryStore: entryStore)
    }
    
    func makeBrainDumpViewModel() -> BrainDumpViewModel {
        BrainDumpViewModel(entryStore: entryStore)
    }
}
