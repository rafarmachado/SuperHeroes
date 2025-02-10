//
//  Untitled.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class MarvelCharacterTests: XCTestCase {

    // ✅ Teste de inicialização e propriedades básicas
    func testMarvelCharacterInitialization_ShouldSetPropertiesCorrectly() {
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Spider-Man")
        XCTAssertEqual(character.description, "Hero")
        XCTAssertNil(character.thumbnail)
    }

    // ✅ Teste de igualdade (deve comparar apenas pelo ID)
    func testMarvelCharacterEquality_ShouldBeEqualWithSameID() {
        let character1 = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        let character2 = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)

        XCTAssertEqual(character1, character2, "Personagens com o mesmo ID devem ser considerados iguais")
    }

    func testMarvelCharacterEquality_ShouldNotBeEqualWithDifferentID() {
        let character1 = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        let character2 = MarvelCharacter(id: 2, name: "Iron Man", description: "Genius", thumbnail: nil)

        XCTAssertNotEqual(character1, character2, "Personagens com IDs diferentes não devem ser considerados iguais")
    }

    // ✅ Teste de Hashable
    func testMarvelCharacterHashable_ShouldHashByID() {
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        let characterSet: Set<MarvelCharacter> = [character]

        XCTAssertTrue(characterSet.contains(character), "Conjuntos devem identificar personagens pelo ID")
    }

    // ✅ Teste de conversão de Thumbnail para URL completa
    func testMarvelCharacterImageUrl_ShouldReturnCorrectURL() {
        let thumbnail = Thumbnail(path: "http://example.com/image", fileExtension: "jpg")
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: thumbnail)

        XCTAssertEqual(character.imageUrl, "https://example.com/image.jpg")
    }
}
