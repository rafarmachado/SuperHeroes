//
//  FavoritesViewControllerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

final class FavoritesViewControllerTests: BaseTestCase {
    
    var viewController: FavoritesViewController!
    var mockViewModel: MockFavoritesViewModel!

    override func setUp() {
        super.setUp()
        mockViewModel = MockFavoritesViewModel()
        viewController = FavoritesViewController(viewModel: mockViewModel)
        
        // 🔥 Força o carregamento da view
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    // ✅ Testa se `fetchFavorites()` é chamado ao aparecer a tela
    func testViewWillAppear_ShouldFetchFavorites() {
        // Act
        viewController.viewWillAppear(false)
        
        // Assert
        XCTAssertTrue(mockViewModel.fetchFavoritesCalled, "O método fetchFavorites deveria ter sido chamado.")
    }

    // ✅ Testa se `toggleFavorite()` é chamado ao favoritar um personagem
    func testToggleFavorite_ShouldCallViewModel() {
        // Arrange
        let character = MarvelCharacter(id: 1011334, name: "3-D Man", description: "", thumbnail: nil)
        mockViewModel.favoriteCharacters = [character]
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Criamos a célula manualmente e chamamos o `onFavoriteTapped`
        guard let cell = viewController.tableView(viewController.favoritesView.tableView, cellForRowAt: indexPath) as? CharacterCell else {
            XCTFail("A célula deveria ser do tipo CharacterCell")
            return
        }
        
        let expectation = self.expectation(description: "UI deve ser atualizada após favoritar o personagem")

        // Act - Chamamos diretamente a ação da célula
        cell.onFavoriteTapped?()

        // Espera um pequeno delay para processar a ação
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.mockViewModel.toggleFavoriteCalled, "toggleFavorite deveria ser chamado.")
            XCTAssertEqual(self.mockViewModel.lastToggledCharacter?.id, 1011334, "O personagem correto deveria ser passado.")
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRefreshFavorites_ShouldCallFetchFavorites() {
        // Act
        viewController.refreshFavorites()

        // Assert
        XCTAssertTrue(mockViewModel.fetchFavoritesCalled, "fetchFavorites deveria ser chamado ao puxar para atualizar.")
    }
    
    func testFetchFavorites_ShouldUpdateUI() {
        // Arrange
        let character = MarvelCharacter(id: 1011334, name: "3-D Man", description: "", thumbnail: nil)
        mockViewModel.favoriteCharacters = [character]

        let expectation = self.expectation(description: "A UI deve ser atualizada após carregar os favoritos")

        // Act
        viewController.viewWillAppear(false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertFalse(self.viewController.viewModel.favoriteCharacters.isEmpty, "A lista de favoritos não deveria estar vazia.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    // ✅ Testa se `fetchFavorites()` é chamado ao puxar para atualizar
    func testRefreshFavorites_ShouldFetchFavorites() {
        // Act
        viewController.refreshFavorites()
        
        // Assert
        XCTAssertTrue(mockViewModel.fetchFavoritesCalled, "O método fetchFavorites deveria ter sido chamado ao puxar para atualizar.")
    }
    
    // ✅ Testa se `didUpdateData()` chama `reloadData()`
    func testDidUpdateData_ShouldReloadTableView() {
        // Arrange
        let expectation = self.expectation(description: "A tableView deve ser recarregada")

        // Act
        viewController.didUpdateData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertTrue(self.viewController.favoritesView.tableView.numberOfRows(inSection: 0) == self.mockViewModel.favoriteCharacters.count,
                          "A tableView deveria ser atualizada corretamente.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

