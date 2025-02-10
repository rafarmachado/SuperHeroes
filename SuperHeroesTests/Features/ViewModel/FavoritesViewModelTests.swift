//
//  FavoritesViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

final class FavoritesViewModelTests: BaseTestCase {
    
    private var viewModel: FavoritesViewModel!
    private var mockFavoritesRepository: MockFavoritesRepository!
    private var mockDelegate: MockViewModelDelegate!
    
    
    override func setUp() {
        super.setUp()
        mockFavoritesRepository = MockFavoritesRepository()
        mockDelegate = MockViewModelDelegate()
        viewModel = FavoritesViewModel(favoritesRepository: mockFavoritesRepository)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockFavoritesRepository = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    /// ✅ Testa se `fetchFavorites()` carrega corretamente os favoritos
    func testFetchFavorites_ShouldUpdateFavoritesList() {
        let character = MarvelCharacter(id: 1011334, name: "3-D Man", description: nil, thumbnail: nil)
        mockFavoritesRepository.addOrRemoveFavorite(character: character)

        let expectation = self.expectation(description: "Deve atualizar a lista de favoritos")

        viewModel.fetchFavorites()

        // ✅ Aguarda a execução assíncrona antes de verificar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockDelegate.didUpdateDataCalled, "Os dados deveriam ser atualizados.")
            XCTAssertFalse(self.viewModel.favoriteCharacters.isEmpty, "A lista de favoritos não deveria estar vazia.")
            XCTAssertEqual(self.viewModel.favoriteCharacters.first?.id, 1011334, "O personagem favoritado deveria estar na lista.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    /// ✅ Testa se `fetchFavorites()` exibe erro quando não há personagens favoritados
    func testFetchFavorites_WhenNoFavorites_ShouldShowError() {
        let expectation = self.expectation(description: "Deve retornar erro por lista vazia")

        viewModel.fetchFavorites()

        // ✅ Aguarda execução assíncrona antes de verificar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockDelegate.didReceiveErrorCalled, "Deveria exibir um erro.")
            XCTAssertEqual(self.mockDelegate.lastErrorMessage, "Nenhum personagem favoritado ainda.",
                           "A mensagem de erro deveria ser correta.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    /// ✅ Testa se `toggleFavorite()` adiciona e remove corretamente
    func testToggleFavorite_ShouldAddOrRemoveFavorite() {
        let character = MarvelCharacter(id: 1011334, name: "3-D Man", description: nil, thumbnail: nil)

        viewModel.toggleFavorite(for: character)
        XCTAssertTrue(viewModel.isFavorite(characterId: character.id), "O personagem deveria estar favoritado.")

        viewModel.toggleFavorite(for: character)
        XCTAssertFalse(viewModel.isFavorite(characterId: character.id), "O personagem não deveria estar mais favoritado.")
    }
    
    /// ✅ Testa se `isFavorite()` retorna corretamente se um personagem está favoritado
    func testIsFavorite_ShouldReturnCorrectStatus() {
        let character = MarvelCharacter(id: 1011334, name: "3-D Man", description: nil, thumbnail: nil)

        mockFavoritesRepository.addOrRemoveFavorite(character: character)
        XCTAssertTrue(viewModel.isFavorite(characterId: character.id), "O personagem deveria estar favoritado.")

        mockFavoritesRepository.addOrRemoveFavorite(character: character)
        XCTAssertFalse(viewModel.isFavorite(characterId: character.id), "O personagem não deveria mais ser favorito.")
    }
}
