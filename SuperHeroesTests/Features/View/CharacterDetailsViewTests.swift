//
//  CharacterDetailViewTests.swift
//  SuperHeroesTests
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharacterDetailViewTests: XCTestCase {
    
    private var characterDetailView: CharacterDetailView!
    
    override func setUp() {
        super.setUp()
        characterDetailView = CharacterDetailView()
    }
    
    override func tearDown() {
        characterDetailView = nil
        super.tearDown()
    }
    
    /// ✅ Testa se a `CharacterDetailView` é inicializada corretamente
    func testInit_ShouldHaveCorrectSubviews() {
        XCTAssertNotNil(characterDetailView.characterImageView, "A imagem do personagem deveria existir.")
        XCTAssertNotNil(characterDetailView.nameLabel, "O nome do personagem deveria existir.")
        XCTAssertNotNil(characterDetailView.descriptionLabel, "A descrição do personagem deveria existir.")
        XCTAssertNotNil(characterDetailView.favoriteButton, "O botão de favoritar deveria existir.")
        XCTAssertNotNil(characterDetailView.shareButton, "O botão de compartilhar deveria existir.")
        XCTAssertNotNil(characterDetailView.activityIndicator, "O indicador de carregamento deveria existir.")
    }

    /// ✅ Testa se a `configure()` atualiza os componentes corretamente
    func testConfigure_ShouldUpdateUIElements() {
        let character = MarvelCharacter(id: 1011334, name: "Spider-Man", description: "Herói da Marvel", thumbnail: nil)
        
        characterDetailView.configure(with: character, isFavorite: false)
        
        XCTAssertEqual(characterDetailView.nameLabel.text, "Spider-Man", "O nome do personagem deveria ser atualizado corretamente.")
        XCTAssertEqual(characterDetailView.descriptionLabel.text, "Herói da Marvel", "A descrição deveria ser atualizada corretamente.")
        XCTAssertEqual(characterDetailView.favoriteButton.title(for: .normal), "⭐ Favoritar", "O botão deveria indicar que o personagem ainda não é favorito.")
    }

    /// ✅ Testa se `configure()` exibe mensagem padrão quando não há descrição
    func testConfigure_WhenDescriptionIsEmpty_ShouldShowDefaultMessage() {
        let character = MarvelCharacter(id: 1011334, name: "Iron Man", description: "", thumbnail: nil)
        
        characterDetailView.configure(with: character, isFavorite: false)
        
        XCTAssertEqual(characterDetailView.descriptionLabel.text, "Detalhes não disponíveis", "A descrição deveria exibir um texto padrão quando estiver vazia.")
    }
    
    /// ✅ Testa se `setImage()` atualiza corretamente a imagem do personagem
    func testSetImage_ShouldUpdateCharacterImage() {
        let mockImage = UIImage(systemName: "star")
        
        characterDetailView.setImage(mockImage)
        
        XCTAssertEqual(characterDetailView.characterImageView.image, mockImage, "A imagem do personagem deveria ser atualizada corretamente.")
    }

    /// ✅ Testa se `updateFavoriteButton()` altera o texto corretamente
    func testUpdateFavoriteButton_ShouldChangeTitle() {
        characterDetailView.updateFavoriteButton(isFavorite: true)
        XCTAssertEqual(characterDetailView.favoriteButton.title(for: .normal), "⭐ Remover Favorito", "O botão deveria indicar que o personagem já é favorito.")
        
        characterDetailView.updateFavoriteButton(isFavorite: false)
        XCTAssertEqual(characterDetailView.favoriteButton.title(for: .normal), "⭐ Favoritar", "O botão deveria indicar que o personagem ainda não é favorito.")
    }
    
    /// ✅ Testa se `toggleLoading(true)` exibe corretamente o indicador de carregamento
    func testToggleLoading_ShouldShowAndHideActivityIndicator() {
        characterDetailView.toggleLoading(true)
        XCTAssertTrue(characterDetailView.activityIndicator.isAnimating, "O indicador de carregamento deveria estar ativo.")
        
        characterDetailView.toggleLoading(false)
        XCTAssertFalse(characterDetailView.activityIndicator.isAnimating, "O indicador de carregamento deveria estar inativo.")
    }

    /// ✅ Testa se `showError()` exibe a mensagem corretamente
    func testShowError_ShouldDisplayErrorMessage() {
        characterDetailView.showError("Erro ao carregar dados")
        
        XCTAssertEqual(characterDetailView.descriptionLabel.text, "Erro ao carregar dados", "A mensagem de erro deveria ser exibida corretamente.")
        XCTAssertEqual(characterDetailView.descriptionLabel.textColor, .systemRed, "A cor da mensagem de erro deveria ser vermelha.")
    }
    
    /// ✅ Testa se `getCharacterImage()` retorna corretamente a imagem atual
    func testGetCharacterImage_ShouldReturnCorrectImage() {
        let mockImage = UIImage(systemName: "star")
        characterDetailView.setImage(mockImage)
        
        XCTAssertEqual(characterDetailView.getCharacterImage(), mockImage, "O método deveria retornar a imagem correta.")
    }
    
    /// ✅ Testa se `onFavoriteTapped` é chamado ao tocar no botão de favoritos
    func testFavoriteButtonTapped_ShouldTriggerCallback() {
        let expectation = self.expectation(description: "O callback de favoritar deveria ser chamado.")
        
        characterDetailView.onFavoriteTapped = {
            expectation.fulfill()
        }
        
        characterDetailView.favoriteButton.sendActions(for: .touchUpInside)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// ✅ Testa se `onShareTapped` é chamado ao tocar no botão de compartilhar
    func testShareButtonTapped_ShouldTriggerCallback() {
        let expectation = self.expectation(description: "O callback de compartilhar deveria ser chamado.")
        
        characterDetailView.onShareTapped = {
            expectation.fulfill()
        }
        
        characterDetailView.shareButton.sendActions(for: .touchUpInside)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
