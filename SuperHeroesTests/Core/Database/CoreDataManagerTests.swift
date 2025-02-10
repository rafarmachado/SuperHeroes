//
//  CoreDataManagerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
import CoreData
@testable import SuperHeroes

final class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManagerProtocol!

    override func setUp() {
        super.setUp()
        coreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }

    func testSaveContext_ShouldNotThrowError() {
        do {
            try coreDataManager.saveContext()
        } catch {
            XCTFail("Save context should not throw error: \(error.localizedDescription)")
        }
    }

    func testDeleteObject_ShouldRemoveObjectAndSaveContext() {
        let context = coreDataManager.viewContext

        // ✅ Criando entidade corretamente
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "FavoriteCharacter", in: context) else {
            XCTFail("Failed to get entity description for FavoriteCharacter")
            return
        }

        let entity = FavoriteCharacter(entity: entityDescription, insertInto: context)
        entity.id = 999
        entity.name = "Test Character"

        do {
            try coreDataManager.saveContext()
        } catch {
            XCTFail("Failed to save mock object: \(error.localizedDescription)")
        }

        XCTAssertNotNil(entity, "Mock entity should exist before deletion")

        coreDataManager.deleteObject(entity)

        let fetchRequest = NSFetchRequest<FavoriteCharacter>(entityName: "FavoriteCharacter")
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertTrue(results.isEmpty, "Object should be deleted from Core Data")
        } catch {
            XCTFail("Failed to fetch objects: \(error.localizedDescription)")
        }
    }
}
