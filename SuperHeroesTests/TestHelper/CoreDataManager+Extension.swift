//
//  CoreDataManager+Extension.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 10/02/25.
//

import CoreData
@testable import SuperHeroes

extension CoreDataManager {
    // MARK: - Reset Database

    /// Completely resets the Core Data database, removing all stored data.
    func resetDatabase() {
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print("Error resetting Core Data: \(error.localizedDescription)")
        }
    }
}
