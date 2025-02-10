//
//  HasHelperTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class HashHelperTests: XCTestCase {
    
    func testGenerateMD5() {
        let input = "test123"
        let expectedMD5 = "cc03e747a6afbbcbf8be7668acfebee5" // MD5 hash gerado manualmente
        
        let generatedMD5 = HashHelper.generateMD5(from: input)
        
        XCTAssertEqual(generatedMD5, expectedMD5, "O hash MD5 gerado deve corresponder ao esperado.")
    }
    
    func testGenerateMD5_EmptyString() {
        let input = ""
        let expectedMD5 = "d41d8cd98f00b204e9800998ecf8427e" // MD5 do string vazio
        
        let generatedMD5 = HashHelper.generateMD5(from: input)
        
        XCTAssertEqual(generatedMD5, expectedMD5, "O hash MD5 de uma string vazia deve ser válido.")
    }
}
