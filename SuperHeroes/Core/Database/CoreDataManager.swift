//
//  CoreDataManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 04/02/25.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case saveFailed(String)
}

/// Protocol for managing Core Data operations, allowing mocks for testing.
protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func backgroundContext() -> NSManagedObjectContext
    func saveContext() throws
    func saveContextInBackground()
    func fetchObjects<T: NSManagedObject>(ofType type: T.Type) -> [T]
    func fetchObjects<T: NSManagedObject>(ofType type: T.Type, predicate: NSPredicate) -> [T]
    func deleteObject(_ object: NSManagedObject)
    func deleteAllObjects<T: NSManagedObject>(ofType type: T.Type)
}

/// Default implementation of `CoreDataManager`, used in the app.
final class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    
    init() {}
    
    // MARK: - Persistent Container
    
    /// The main Core Data container that manages the database.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SuperHeroesDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    /// Returns the main Core Data context.
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Creates a background context for asynchronous operations.
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // MARK: - Save Context
    
    /// Saves the main context, throwing an error if it fails.
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let errorMessage = "Error saving Core Data context: \(error.localizedDescription)"
                throw CoreDataError.saveFailed(errorMessage)
            }
        }
    }
    
    /// Asynchronously saves data in a background context.
    func saveContextInBackground() {
        let context = backgroundContext()
        context.perform {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data in background: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch Objects
    
    /// Retrieves all objects of a given type.
    func fetchObjects<T: NSManagedObject>(ofType type: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching \(type): \(error.localizedDescription)")
            return []
        }
    }
    
    /// Retrieves objects filtered by an `NSPredicate`.
    func fetchObjects<T: NSManagedObject>(ofType type: T.Type, predicate: NSPredicate) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = predicate
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching \(type) with predicate: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Delete Objects
    
    /// Removes a specific object from Core Data.
    func deleteObject(_ object: NSManagedObject) {
        viewContext.delete(object)
        do {
            try saveContext()
        } catch {
            print("⚠️ Error saving context after deleting object: \(error.localizedDescription)")
        }
    }
    
    /// Removes all objects of a specific entity.
    func deleteAllObjects<T: NSManagedObject>(ofType type: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
            try saveContext()
        } catch {
            print("⚠️ Error deleting all \(type) objects: \(error.localizedDescription)")
        }
    }
}
