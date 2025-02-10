//
//  MockCharactersViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import Foundation
@testable import SuperHeroes

final class MockCharactersViewModel: CharactersViewModelProtocol {
    var delegate: ViewModelDelegate?
    var filteredCharacters: [MarvelCharacter] = [
        MarvelCharacter(id: 1, name: "Spider-Man", description: "Friendly neighborhood hero", thumbnail: nil),
        MarvelCharacter(id: 2, name: "Iron Man", description: "Genius billionaire playboy philanthropist", thumbnail: nil),
        MarvelCharacter(id: 3, name: "Hulk", description: "The strongest Avenger", thumbnail: nil)
    ]

    func fetchCharacters(forceUpdate: Bool) {
        delegate?.didUpdateData()
    }

    func loadMoreCharacters() {}

    func searchCharacter(with query: String) {
        filteredCharacters = filteredCharacters.filter { $0.name.contains(query) }
        delegate?.didUpdateData()
    }

    func toggleFavorite(for character: MarvelCharacter) {}

    func isFavorite(characterId: Int) -> Bool {
        return characterId == 1 // Simula que apenas o Spider-Man é favorito
    }

    func updateFavoriteStatus(for character: MarvelCharacter) {}
}
