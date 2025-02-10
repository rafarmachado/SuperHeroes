//
//  CharacterCellTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharacterCellTests: XCTestCase {

    var cell: CharacterCell!
    var character: MarvelCharacter!

    override func setUp() {
        super.setUp()
        cell = CharacterCell(style: .default, reuseIdentifier: CharacterCell.identifier)
        character = MarvelCharacter(
            id: 1,
            name: "Spider-Man",
            description: "Amigão da Vizinhança",
            thumbnail: Thumbnail(path: "https://example.com/image", fileExtension: "jpg")
        )
    }

    override func tearDown() {
        cell = nil
        character = nil
        super.tearDown()
    }

    // ✅ Testa se a célula inicializa corretamente
    func testCell_Initialization() {
        XCTAssertNotNil(cell, "A célula deveria ser inicializada corretamente.")
        XCTAssertEqual(cell.selectionStyle, .none, "O estilo de seleção deveria ser 'none'.")
        XCTAssertEqual(cell.backgroundColor, .systemBackground, "O fundo da célula deveria ser o fundo padrão do sistema.")
    }

    // ✅ Testa se a célula configura corretamente com um personagem e favorito
    func testConfigureCell_WithCharacterAndFavorite() {
        cell.configure(with: character, isFavorite: true)

        XCTAssertEqual(cell.character?.id, character.id, "O personagem atribuído deveria ser o correto.")
        XCTAssertEqual(cell.nameLabel.text, character.name, "O nome do personagem deveria ser exibido corretamente.")
        XCTAssertTrue(cell.isFavorite, "O personagem deveria estar marcado como favorito.")
        XCTAssertEqual(cell.favoriteButton.imageView?.image, UIImage(systemName: "star.fill"), "O botão de favorito deveria exibir um ícone preenchido.")
    }

    // ✅ Testa se o botão de favorito é atualizado corretamente ao configurar a célula
    func testUpdateFavoriteButton() {
        cell.isFavorite = false
        cell.configure(with: character, isFavorite: true)

        XCTAssertEqual(cell.favoriteButton.imageView?.image, UIImage(systemName: "star.fill"), "O botão de favorito deveria exibir um ícone preenchido quando favoritado.")

        cell.configure(with: character, isFavorite: false)

        XCTAssertEqual(cell.favoriteButton.imageView?.image, UIImage(systemName: "star"), "O botão de favorito deveria exibir um ícone vazio quando não favoritado.")
    }

    // ✅ Testa se o botão de favorito chama a closure corretamente
    func testFavoriteButtonTapped_ShouldTriggerClosure() {
        let expectation = XCTestExpectation(description: "Ação do botão de favorito deveria ser chamada.")

        cell.onFavoriteTapped = {
            expectation.fulfill()
        }

        cell.didTapFavorite()

        wait(for: [expectation], timeout: 1.0)
    }
}
