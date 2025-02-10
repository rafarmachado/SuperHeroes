//
//  MockCoreDataManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 10/02/25.
//

import CoreData
import XCTest
@testable import SuperHeroes

final class MockCoreDataManager: CoreDataManagerProtocol {
    let container: NSPersistentContainer
    let mockContext: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "SuperHeroesDataModel") // ✅ Nome correto do modelo
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // ✅ Banco em memória para testes
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Erro ao carregar o banco de dados em memória: \(String(describing: error))")
        }

        mockContext = container.viewContext
    }
    
    var viewContext: NSManagedObjectContext {
        return mockContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    func saveContext() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    func saveContextInBackground() { }

    func fetchObjects<T: NSManagedObject>(ofType type: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func fetchObjects<T: NSManagedObject>(ofType type: T.Type, predicate: NSPredicate) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = predicate
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func deleteObject(_ object: NSManagedObject) {
        viewContext.delete(object)
    }
    
    func deleteAllObjects<T: NSManagedObject>(ofType type: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
        } catch {
            print("Failed to delete all objects: \(error.localizedDescription)")
        }
    }
}
