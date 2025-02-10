//
//  CharactersViewTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharactersViewTests: XCTestCase {
    
    var characterView: CharactersView!
    
    override func setUp() {
        super.setUp()
        characterView = CharactersView()
    }
    
    override func tearDown() {
        characterView = nil
        super.tearDown()
    }

    // ✅ Testa se o botão de retry está oculto por padrão
    func testRetryButton_ShouldBeHiddenInitially() {
        XCTAssertTrue(characterView.retryButton.isHidden,
                      "O botão de retry deveria estar oculto por padrão.")
    }

    // ✅ Testa se o botão de retry aparece corretamente
    func testShowRetryButton_ShouldShowButton() {
        characterView.showRetryButton(true)
        XCTAssertFalse(characterView.retryButton.isHidden,
                       "O botão de retry deveria estar visível.")
    }

    // ✅ Testa se o botão de retry desaparece corretamente
    func testShowRetryButton_ShouldHideButton() {
        characterView.showRetryButton(false)
        XCTAssertTrue(characterView.retryButton.isHidden,
                      "O botão de retry deveria estar oculto.")
    }
    
    // ✅ Testa se o `searchController` está configurado corretamente
    func testSearchController_ShouldBeProperlyConfigured() {
        let searchBar = characterView.searchController.searchBar
        
        XCTAssertEqual(searchBar.placeholder, "Buscar personagens...",
                       "O placeholder da barra de pesquisa deveria ser 'Buscar personagens...'.")
        XCTAssertEqual(searchBar.autocapitalizationType, .none,
                       "A barra de pesquisa não deveria capitalizar o texto.")
        XCTAssertEqual(searchBar.searchBarStyle, .minimal,
                       "A barra de pesquisa deveria ter um estilo minimalista.")
    }
}
