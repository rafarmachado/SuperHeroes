//
//  MockFavoritesViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import UIKit
@testable import SuperHeroes

final class MockFavoritesViewModel: FavoritesViewModelProtocol {
    
    var delegate: ViewModelDelegate?
    var favoriteCharacters: [MarvelCharacter] = []
    
    var fetchFavoritesCalled = false
    var toggleFavoriteCalled = false
    var loadImageCalled = false
    var lastToggledCharacter: MarvelCharacter?
    
    func fetchFavorites() {
        fetchFavoritesCalled = true
        delegate?.didUpdateLoadingState(isLoading: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Simula tempo de carregamento
            self.favoriteCharacters = [
                MarvelCharacter(id: 1011334, name: "3-D Man", description: "", thumbnail: nil)
            ]
            self.delegate?.didUpdateData()
            self.delegate?.didUpdateLoadingState(isLoading: false)
        }
    }
    
    func toggleFavorite(for character: MarvelCharacter) {
        toggleFavoriteCalled = true
        lastToggledCharacter = character
        delegate?.didUpdateData()
    }
    
    func isFavorite(characterId: Int) -> Bool {
        return favoriteCharacters.contains { $0.id == characterId }
    }
    
    /// ✅ Adicionando Mock para `loadImage`
    func loadImage(for character: MarvelCharacter, completion: @escaping (UIImage?) -> Void) {
        loadImageCalled = true
        let mockImage = UIImage(systemName: "star") // Simula uma imagem carregada
        completion(mockImage)
    }
}
