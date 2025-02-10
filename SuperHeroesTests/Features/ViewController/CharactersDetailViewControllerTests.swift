//
//  CharactersDetailViewControllerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharacterDetailViewControllerTests: BaseTestCase {
    
    var viewController: CharacterDetailViewController!
    var mockViewModel: MockCharacterDetailViewModel!
    
    override func setUp() {
        super.setUp()
        
        let mockCharacter = MarvelCharacter(id: 1011334, name: "3-D Man", description: "Teste", thumbnail: nil)
        mockViewModel = MockCharacterDetailViewModel(character: mockCharacter)
        viewController = CharacterDetailViewController(viewModel: mockViewModel)
        
        // Força a inicialização da View
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    /// Testa se a ViewController pode ser inicializada corretamente com um personagem
    func testInitWithCharacter_ShouldCreateViewModel() {
        let character = MarvelCharacter(id: 1011334, name: "3-D Man", description: "Teste", thumbnail: nil)
        let vc = CharacterDetailViewController(character: character)
        
        XCTAssertNotNil(vc, "A ViewController deveria ser criada corretamente.")
        XCTAssertEqual(vc.viewModel.character.id, character.id, "O personagem inicializado deveria ser correto.")
    }
    
    /// Testa se `loadCharacterData()` é chamado corretamente no `viewDidLoad`
    func testViewDidLoad_ShouldCallLoadCharacterData() {
        XCTAssertTrue(mockViewModel.loadCharacterDataCalled, "loadCharacterData deveria ser chamado ao carregar a tela.")
    }
    
    /// Testa se a tab bar é **escondida** ao entrar na tela
    func testViewWillAppear_ShouldHideTabBar() {
        let mockTabBarController = MockTabBarController()
        mockTabBarController.viewControllers = [viewController]
        
        viewController.viewWillAppear(false)
        
        XCTAssertTrue(mockTabBarController.lastTabBarHiddenState, "A tab bar deveria ser escondida ao entrar na tela.")
    }
    
    /// Testa se a tab bar **reaparece** ao sair da tela
    func testViewWillDisappear_ShouldShowTabBar() {
        // Arrange
        let mockTabBarController = MockTabBarController()
        mockTabBarController.viewControllers = [viewController]

        // Act
        viewController.viewWillDisappear(false)

        // Assert
        XCTAssertFalse(mockTabBarController.lastTabBarHiddenState, "A tab bar deveria reaparecer ao sair da tela.")
    }
    
    /// Testa se ao favoritar um personagem, `toggleFavorite()` da ViewModel é chamado
    func testToggleFavorite_ShouldCallViewModel() {
        viewController.handleFavoriteAction()
        XCTAssertTrue(mockViewModel.toggleFavoriteCalled, "toggleFavorite deveria ser chamado.")
    }
    
    /// Testa se a tela exibe corretamente uma imagem quando `onImageLoaded` é acionado
    func testImageLoaded_ShouldUpdateImageView() {
        let mockImage = UIImage()
        mockViewModel.onImageLoaded?(mockImage)
        
        XCTAssertEqual(viewController.characterDetailView.getCharacterImage(), mockImage, "A imagem do personagem deveria ser atualizada.")
    }
    
    /// Testa se um erro é recebido e exibido corretamente na `descriptionLabel`
    func testOnError_ShouldShowErrorMessage() {
        let errorMessage = "Erro ao carregar a imagem."
        mockViewModel.onError?(errorMessage)
        
        XCTAssertEqual(viewController.characterDetailView.descriptionLabel.text, errorMessage, "A mensagem de erro deveria ser exibida corretamente.")
    }
}
