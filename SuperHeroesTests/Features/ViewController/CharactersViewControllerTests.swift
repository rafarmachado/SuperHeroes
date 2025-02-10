//
//  CharactersViewControllerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//
//
//  CharactersViewControllerTests.swift
//  SuperHeroesTests
//
//  Created by Rafael Rezende Machado on 10/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharactersViewControllerTests: BaseTestCase {

    var viewController: CharactersViewController!
    var mockViewModel: MockCharactersViewModel!
    var mockNavigationController: UINavigationController!

    override func setUp() {
        super.setUp()
        mockViewModel = MockCharactersViewModel()
        viewController = CharactersViewController(viewModel: mockViewModel)
        mockNavigationController = UINavigationController(rootViewController: viewController)
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockNavigationController = nil
        super.tearDown()
    }

    // ✅ Teste de inicialização
    func testViewController_ShouldInitializeCorrectly() {
        XCTAssertNotNil(viewController.characterView, "A view do controlador não deveria ser nula")
        XCTAssertNotNil(viewController.viewModel, "O ViewModel não deveria ser nulo")
    }

    // ✅ Teste de chamada de fetchCharacters no viewDidLoad
    func testViewDidLoad_ShouldFetchCharacters() {
        XCTAssertTrue(mockViewModel.fetchCharactersCalled, "fetchCharacters deveria ser chamado no viewDidLoad")
    }

    // ✅ Teste de exibição do botão retry após erro
    func testDidReceiveError_ShouldSetIsLoadingMoreToFalse() {
        let expectation = XCTestExpectation(description: "didReceiveError deve ser chamado corretamente e alterar isLoadingMore")

        // 🔥 Garante que a flag começa como `true`
        viewController.isLoadingMore = true
        
        // 🔥 Chama o método que queremos testar
        viewController.didReceiveError(message: "Erro de Teste")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewController.isLoadingMore, "isLoadingMore deveria estar `false` após erro")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

    // ✅ Teste de esconder botão retry após sucesso
    func testDidUpdateData_ShouldHideRetryButton() {
        mockViewModel.filteredCharacters = [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        ]

        viewController.didUpdateData()

        XCTAssertTrue(viewController.characterView.retryButton.isHidden, "O botão de retry deveria estar escondido após sucesso")
    }

    // ✅ Teste da ação de retry ao clicar no botão
    func testDidTapRetry_ShouldCallFetchCharacters() {
        viewController.didTapRetry()
        XCTAssertTrue(mockViewModel.fetchCharactersCalled, "fetchCharacters deveria ser chamado ao clicar no botão de retry")
    }

    // ✅ Teste de seleção de célula
    func testDidSelectRow_ShouldPushDetailViewController() {
        let mockCharacter = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        mockViewModel.filteredCharacters = [mockCharacter]

        viewController.tableView(viewController.characterView.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(mockNavigationController.topViewController is CharacterDetailViewController, "O detalhe do personagem deveria ser apresentado")
    }

    // ✅ Teste de paginação no scroll
    func testScrollViewDidScroll_ShouldLoadMoreCharacters() {
        viewController.isLoadingMore = false
        viewController.scrollViewDidScroll(viewController.characterView.tableView)

        XCTAssertTrue(mockViewModel.loadMoreCharactersCalled, "loadMoreCharacters deveria ser chamado no scroll")
    }
}
