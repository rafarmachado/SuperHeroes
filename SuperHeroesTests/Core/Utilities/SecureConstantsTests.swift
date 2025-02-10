//
//  SecureConstantsTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class SecureConstantsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        SecureConstants.deletePrivateKey() // Garante que a private key não esteja salva antes do teste
    }
    
    override func tearDown() {
        SecureConstants.deletePrivateKey() // Limpa qualquer chave persistida após o teste
        super.tearDown()
    }
    
    func testBaseURL_FromInfoPlist() {
        let expectedBaseURL = "https://gateway.marvel.com/v1/public/" // Simulação do valor esperado
        XCTAssertEqual(SecureConstants.baseURL, expectedBaseURL, "A baseURL deve ser carregada corretamente do Info.plist.")
    }
    
    func testPublicKey_FromInfoPlist() {
        let expectedPublicKey = "1febf2fec67d7e1023019331a07a842a" // Simulação do valor esperado
        XCTAssertEqual(SecureConstants.publicKey, expectedPublicKey, "A publicKey deve ser carregada corretamente do Info.plist.")
    }
    
    func testSaveAndRetrievePrivateKey_FromKeychain() {
        let testKey = "test_private_key_12345"
        SecureConstants.savePrivateKey(testKey)
        let retrievedKey = KeychainHelper.shared.get(forKey: "privateKey")
        
        XCTAssertEqual(retrievedKey, testKey, "A chave privada deve ser salva e recuperada corretamente do Keychain.")
    }
    
    func testDeletePrivateKey() {
        let testKey = "test_private_key_12345"
        SecureConstants.savePrivateKey(testKey)
        SecureConstants.deletePrivateKey()
        let retrievedKey = KeychainHelper.shared.get(forKey: "privateKey")
        
        XCTAssertNil(retrievedKey, "A chave privada deve ser removida corretamente do Keychain.")
    }
}
