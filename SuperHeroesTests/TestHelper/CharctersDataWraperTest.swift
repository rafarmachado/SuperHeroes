//
//  CharctersDataWraperTest.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharacterDataWrapperTests: XCTestCase {

    // ✅ Teste de decodificação de JSON
    func testCharacterDataWrapper_ShouldDecodeJSONCorrectly() {
        let json = """
        {
            "code": 200,
            "status": "OK",
            "data": {
                "offset": 0,
                "limit": 20,
                "total": 100,
                "count": 1,
                "results": [
                    {
                        "id": 1,
                        "name": "Spider-Man",
                        "description": "Hero",
                        "thumbnail": {
                            "path": "http://example.com/image",
                            "extension": "jpg"
                        }
                    }
                ]
            }
        }
        """.data(using: .utf8)!

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(CharacterDataWrapper.self, from: json)

            XCTAssertEqual(decodedData.code, 200)
            XCTAssertEqual(decodedData.status, "OK")
            XCTAssertEqual(decodedData.data.results.count, 1)
            XCTAssertEqual(decodedData.data.results.first?.name, "Spider-Man")
            XCTAssertEqual(decodedData.data.results.first?.imageUrl, "https://example.com/image.jpg")

        } catch {
            XCTFail("Decodificação falhou: \(error)")
        }
    }
}
