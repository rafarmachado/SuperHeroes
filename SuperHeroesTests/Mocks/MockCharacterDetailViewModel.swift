//
//  MockCharacterDetailViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import UIKit
@testable import SuperHeroes

final class MockCharacterDetailViewModel: CharacterDetailViewModelProtocol {
    var character: MarvelCharacter
    var onImageLoaded: ((UIImage?) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onFavoriteStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    var loadCharacterDataCalled = false
    var toggleFavoriteCalled = false
    private var isFavorite = false

    init(character: MarvelCharacter) {
        self.character = character
    }

    func loadCharacterData() {
        loadCharacterDataCalled = true
    }

    func isCharacterFavorite() -> Bool {
        return isFavorite
    }

    func toggleFavorite() {
        toggleFavoriteCalled = true
        isFavorite.toggle()
        onFavoriteStateChanged?(isFavorite)
    }
}
