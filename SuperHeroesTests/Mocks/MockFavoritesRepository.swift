//
//  MockFavoritesRepository.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//
import XCTest
@testable import SuperHeroes

final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    private var favorites: [MarvelCharacter] = []
    var isFavoriteCalled = false
    var toggleFavoriteCalled = false


    func addOrRemoveFavorite(character: MarvelCharacter) {
        toggleFavoriteCalled = true
        if let index = favorites.firstIndex(where: { $0.id == character.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(character)
        }
    }

    func isFavorite(characterId: Int) -> Bool {
        isFavoriteCalled = true
        return favorites.contains { $0.id == characterId }
    }
    
    func getFavorites() -> [MarvelCharacter] {
        return favorites
    }
    
    func clearFavorites() {
        favorites.removeAll()
    }
    
}
