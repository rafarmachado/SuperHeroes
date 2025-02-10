//
//  CharactersDetailsViewModelTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//
import XCTest
@testable import SuperHeroes

final class CharacterDetailViewModelTests: BaseTestCase {
    
    private var viewModel: CharacterDetailViewModel!
    private var mockFavoritesRepository: MockFavoritesRepository!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockFavoritesRepository = MockFavoritesRepository()
        mockURLSession = MockURLSession()
        
        let character = MarvelCharacter(
            id: 1011334,
            name: "3-D Man",
            description: "Some description",
            thumbnail: Thumbnail(path: "https://example.com/image", fileExtension: "jpg")
        )
        
        viewModel = CharacterDetailViewModel(
            character: character,
            imageLoader: ImageLoader(session: mockURLSession),
            favoritesRepository: mockFavoritesRepository
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockFavoritesRepository = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    /// ✅ Testa se `isCharacterFavorite()` retorna corretamente o status
    func testIsCharacterFavorite_ShouldReturnCorrectStatus() {
        XCTAssertFalse(viewModel.isCharacterFavorite(), "O personagem não deveria ser favorito inicialmente.")
        
        mockFavoritesRepository.addOrRemoveFavorite(character: viewModel.character)
        XCTAssertTrue(viewModel.isCharacterFavorite(), "O personagem deveria estar favoritado após a adição.")
    }
    
    /// ✅ Testa se `toggleFavorite()` adiciona e remove corretamente dos favoritos
    func testToggleFavorite_ShouldChangeFavoriteState() {
        let expectation = self.expectation(description: "O estado de favorito deveria ser alterado.")
        
        var updatedState: Bool?
        viewModel.onFavoriteStateChanged = { isFavorite in
            updatedState = isFavorite
            expectation.fulfill()
        }
        
        viewModel.toggleFavorite()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(updatedState, viewModel.isCharacterFavorite(), "O estado de favorito deveria ser atualizado corretamente.")
    }
    
    /// ✅ Testa se `loadCharacterData()` carrega a imagem do cache quando o personagem é favorito
    func testLoadCharacterData_ShouldLoadFromCache_WhenFavorite() {
        let mockImage = UIImage(systemName: "star")!
        CacheManager.shared.saveImage(mockImage, for: viewModel.character.thumbnail!.fullUrl)
        mockFavoritesRepository.addOrRemoveFavorite(character: viewModel.character)

        let expectation = self.expectation(description: "A imagem deveria ser carregada do cache.")

        viewModel.onImageLoaded = { image in
            XCTAssertNotNil(image, "A imagem não deveria ser nula.")
            expectation.fulfill()
        }

        viewModel.loadCharacterData()

        wait(for: [expectation], timeout: 1.0)
    }
    
    /// ✅ Testa se `loadCharacterData()` baixa a imagem corretamente quando não está no cache
    func testLoadCharacterData_ShouldDownloadImage_WhenNotInCache() {
        let expectation = self.expectation(description: "Deveria tentar carregar a imagem da rede.")
        
        var wasRequestMade = false

        viewModel.onImageLoaded = { _ in
            wasRequestMade = true
            expectation.fulfill()
        }

        viewModel.loadCharacterData()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(wasRequestMade, "O método deveria tentar buscar a imagem da rede.")
    }
}
