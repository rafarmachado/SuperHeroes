//
//  CharactersViewModelTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharactersViewModelTests: BaseTestCase {

    var viewModel: CharactersViewModel!
    var mockApiService: MockApiService!
    var mockFavoritesRepository: MockFavoritesRepository!
    var mockDelegate: MockViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        mockFavoritesRepository = MockFavoritesRepository()
        mockDelegate = MockViewModelDelegate()
        
        let charactersService = CharactersService(apiService: mockApiService)
        
        viewModel = CharactersViewModel(
            repository: charactersService,
            favoritesRepository: mockFavoritesRepository
        )
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockApiService = nil
        mockFavoritesRepository = nil
        mockDelegate = nil
        super.tearDown()
    }

    // ✅ Teste de sucesso para fetchCharacters
    func testFetchCharacters_Success_ShouldUpdateData() {
        let expectation = XCTestExpectation(description: "Deve atualizar a UI com novos personagens")

        let mockCharacters = [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil),
            MarvelCharacter(id: 2, name: "Iron Man", description: "Genius Billionaire", thumbnail: nil)
        ]

        let mockResponse = CharacterDataWrapper(
            code: 200,
            status: "OK",
            data: CharacterDataContainer(offset: 0, limit: 20, total: 100, count: 2, results: mockCharacters)
        )

        mockApiService.mockResult = .success(mockResponse)

        viewModel.fetchCharacters(forceUpdate: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didUpdateDataCalled, "A UI deveria ter sido atualizada")
            XCTAssertEqual(self.viewModel.filteredCharacters.count, 2, "Deveria ter dois personagens carregados")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    // ❌ Teste de erro ao buscar personagens
    func testFetchCharacters_Failure_ShouldShowError() {
        let expectation = XCTestExpectation(description: "Deve exibir erro na UI")

        mockApiService.mockResult = .failure(.networkError(NSError(domain: "No Internet", code: -1009, userInfo: nil)))

        viewModel.fetchCharacters(forceUpdate: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didReceiveErrorCalled, "A UI deveria exibir um erro")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    // ✅ Teste de paginação: carregar mais personagens
    func testLoadMoreCharacters_Success_ShouldAppendData() {
        let expectation = XCTestExpectation(description: "Deve adicionar novos personagens")

        let mockNewCharacters = [
            MarvelCharacter(id: 3, name: "Thor", description: "God of Thunder", thumbnail: nil),
            MarvelCharacter(id: 4, name: "Hulk", description: "Strongest Avenger", thumbnail: nil)
        ]

        let mockResponse = CharacterDataWrapper(
            code: 200,
            status: "OK",
            data: CharacterDataContainer(offset: 20, limit: 20, total: 100, count: 2, results: mockNewCharacters)
        )

        mockApiService.mockResult = .success(mockResponse)

        viewModel.loadMoreCharacters()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didUpdateDataCalled, "A UI deveria ser atualizada")
            XCTAssertEqual(self.viewModel.filteredCharacters.count, 2, "Deveria ter dois novos personagens carregados")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    // ❌ Teste de erro na paginação
    func testLoadMoreCharacters_Failure_ShouldShowError() {
        let expectation = XCTestExpectation(description: "Deve exibir erro ao tentar carregar mais personagens")

        mockApiService.mockResult = .failure(.serverError(500))

        viewModel.loadMoreCharacters()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockDelegate.didReceiveErrorCalled, "A UI deveria exibir um erro")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testSearchCharacters_ShouldFilterResults_WithDebounce() {
        let expectation = XCTestExpectation(description: "Deve filtrar corretamente os personagens após debounce")

        let mockCharacters = [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil),
            MarvelCharacter(id: 2, name: "Iron Man", description: "Genius Billionaire", thumbnail: nil)
        ]

        viewModel.allCharacters = mockCharacters

        viewModel.searchCharacter(with: "Iron")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Espera o debounce de 0.3s + margem
            XCTAssertEqual(self.viewModel.filteredCharacters.count, 1, "Deveria ter filtrado apenas 'Iron Man'")
            XCTAssertEqual(self.viewModel.filteredCharacters.first?.name, "Iron Man", "O personagem filtrado deveria ser 'Iron Man'")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }


    func testSearchCharacters_ShouldIgnoreRepeatedQuery() {
        let expectation = XCTestExpectation(description: "Deve ignorar a busca se a query for a mesma da última pesquisa")

        let mockCharacters = [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil),
            MarvelCharacter(id: 2, name: "Iron Man", description: "Genius Billionaire", thumbnail: nil)
        ]

        viewModel.allCharacters = mockCharacters

        viewModel.searchCharacter(with: "Iron")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Espera debounce da primeira chamada
            let firstCount = self.viewModel.filteredCharacters.count

            self.viewModel.searchCharacter(with: "Iron") // Mesma query de novo

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Espera debounce da segunda chamada
                XCTAssertEqual(self.viewModel.filteredCharacters.count, firstCount, "A segunda chamada não deveria alterar o resultado")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.5)
    }

    func testSearchCharacters_ShouldCancelPreviousWorkItem() {
        let expectation = XCTestExpectation(description: "Deve cancelar a pesquisa anterior ao digitar rapidamente uma nova query")

        let mockCharacters = [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil),
            MarvelCharacter(id: 2, name: "Iron Man", description: "Genius Billionaire", thumbnail: nil),
            MarvelCharacter(id: 3, name: "Hulk", description: "Strongest there is", thumbnail: nil)
        ]

        viewModel.allCharacters = mockCharacters

        viewModel.searchCharacter(with: "Iron") // Primeira pesquisa

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Antes do debounce terminar, troca a query
            self.viewModel.searchCharacter(with: "H")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // Espera o debounce da última query
                XCTAssertEqual(self.viewModel.filteredCharacters.count, 1, "Deveria ter filtrado apenas 'Hulk'")
                XCTAssertEqual(self.viewModel.filteredCharacters.first?.name, "Hulk", "O personagem filtrado deveria ser 'Hulk'")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    // ✅ Teste de favoritar personagem
    func testToggleFavorite_ShouldUpdateFavorites() {
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)

        viewModel.toggleFavorite(for: character)

        XCTAssertTrue(mockFavoritesRepository.toggleFavoriteCalled, "O método de favoritar deveria ser chamado")
    }
}
