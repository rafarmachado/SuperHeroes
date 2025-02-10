//
//  MockCharactersViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import Foundation
@testable import SuperHeroes

final class MockCharactersViewModel: CharactersViewModelProtocol {
    
    var delegate: ViewModelDelegate?
    var filteredCharacters: [MarvelCharacter] = []
    
    var fetchCharactersCalled = false
    var loadMoreCharactersCalled = false

    func fetchCharacters(forceUpdate: Bool) {
        fetchCharactersCalled = true
        if forceUpdate {
            filteredCharacters = [
                MarvelCharacter(id: 1, name: "Iron Man", description: "Genius", thumbnail: nil)
            ]
            delegate?.didUpdateData()
        }
    }

    func loadMoreCharacters() {
        loadMoreCharactersCalled = true
        filteredCharacters.append(
            MarvelCharacter(id: 2, name: "Hulk", description: "Strongest Avenger", thumbnail: nil)
        )
        delegate?.didUpdateData()
    }

    func searchCharacter(with query: String) {
        filteredCharacters = filteredCharacters.filter { $0.name.contains(query) }
        delegate?.didUpdateData()
    }

    func toggleFavorite(for character: MarvelCharacter) {}

    func isFavorite(characterId: Int) -> Bool {
        return false
    }

    func updateFavoriteStatus(for character: MarvelCharacter) {}
}
