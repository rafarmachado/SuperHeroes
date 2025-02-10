//
//  CharactersViewControllerUITests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest

final class CharactersViewControllerUITests: BaseTestCase {
    
    var charactersScreen: CharactersScreen!
    
    override func setUp() {
        super.setUp()
        charactersScreen = CharactersScreen(app: app)
        app.launch()
    }
    
    func testCharactersList_ShouldLoadSuccessfully() {
        XCTAssertTrue(charactersScreen.tableView.waitForExistence(timeout: 5), "A lista de personagens não foi carregada.")
        XCTAssertGreaterThan(charactersScreen.tableView.cells.count, 0, "A lista de personagens está vazia.")
    }
    
    func testSearchCharacter_ShouldFilterResults() {
        charactersScreen.searchCharacter(name: "Spider-Man")
        
        let firstCell = charactersScreen.tableView.cells.firstMatch
        XCTAssertTrue(firstCell.staticTexts["Spider-Man"].exists, "O personagem Spider-Man não foi encontrado na busca.")
    }
    
    func testFavoriteCharacter_FromList() {
        let firstCell = charactersScreen.tableView.cells.element(boundBy: 0)
        let favoriteButton = firstCell.buttons["FavoriteButton"]
        
        XCTAssertTrue(favoriteButton.exists, "Botão de favorito não encontrado.")
        
        favoriteButton.tap()
        XCTAssertTrue(favoriteButton.isSelected, "O botão de favorito não mudou de estado.")
    }
    
    func testPagination_ShouldLoadMoreCharacters() {
        let lastCell = charactersScreen.tableView.cells.element(boundBy: charactersScreen.tableView.cells.count - 1)
        app.swipeUp()
        
        XCTAssertTrue(lastCell.waitForExistence(timeout: 5), "A paginação não carregou mais personagens.")
    }
    
    func testErrorState_ShouldShowRetryButton() {
        let mockService = MockCharactersService()
        mockService.shouldFail = true
        
        charactersScreen.tapRetryButton()
        
        XCTAssertTrue(charactersScreen.retryButton.exists, "O botão de tentar novamente não foi exibido após erro de rede.")
    }
}
