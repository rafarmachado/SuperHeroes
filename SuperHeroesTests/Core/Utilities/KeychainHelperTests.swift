//
//  KeychainHelperTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class KeychainHelperTests: XCTestCase {
    
    var keychainHelper: KeychainHelper!
    let testKey = "testKey"
    let testValue = "testValue"
    
    override func setUp() {
        super.setUp()
        keychainHelper = KeychainHelper.shared
        keychainHelper.delete(forKey: testKey) // Garantir que o Keychain está limpo antes de cada teste
    }
    
    override func tearDown() {
        keychainHelper.delete(forKey: testKey) // Limpa após cada teste
        keychainHelper = nil
        super.tearDown()
    }
    
    func testSaveAndRetrieveValue() {
        let saveSuccess = keychainHelper.save(testValue, forKey: testKey)
        XCTAssertTrue(saveSuccess, "O valor deve ser salvo com sucesso no Keychain.")
        
        let retrievedValue = keychainHelper.get(forKey: testKey)
        XCTAssertEqual(retrievedValue, testValue, "O valor recuperado deve ser igual ao valor salvo.")
    }
    
    func testRetrieveNonexistentValue() {
        let retrievedValue = keychainHelper.get(forKey: "nonexistentKey")
        XCTAssertNil(retrievedValue, "A recuperação de uma chave inexistente deve retornar nil.")
    }
    
    func testDeleteValue() {
        keychainHelper.save(testValue, forKey: testKey)
        let deleteSuccess = keychainHelper.delete(forKey: testKey)
        XCTAssertTrue(deleteSuccess, "O valor deve ser deletado com sucesso do Keychain.")
        
        let retrievedValue = keychainHelper.get(forKey: testKey)
        XCTAssertNil(retrievedValue, "O valor deve ser removido e não mais recuperável.")
    }
}
