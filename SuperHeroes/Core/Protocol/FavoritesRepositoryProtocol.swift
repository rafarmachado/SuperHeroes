//
//  FavoritesRepositoryProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

protocol FavoritesRepositoryProtocol {
    func addOrRemoveFavorite(character: MarvelCharacter)
    func isFavorite(characterId: Int) -> Bool
    func getFavorites() -> [MarvelCharacter]
    func clearFavorites()
}
