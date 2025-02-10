//
//  CharactersViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import Foundation
import UIKit

/// Protocol defining the expected functionalities of `CharactersViewModel`.
public protocol CharactersViewModelProtocol {
    var delegate: ViewModelDelegate? { get set }
    var filteredCharacters: [MarvelCharacter] { get }
    
    /// Fetches characters from the repository, with an option to force an update.
    /// - Parameter forceUpdate: If `true`, forces a fresh data fetch.
    func fetchCharacters(forceUpdate: Bool)
    
    /// Loads additional characters for pagination.
    func loadMoreCharacters()
    
    /// Searches for characters based on a given query.
    /// - Parameter query: The search keyword.
    func searchCharacter(with query: String)
    
    /// Toggles the favorite status of a character.
    /// - Parameter character: The `MarvelCharacter` to be updated.
    func toggleFavorite(for character: MarvelCharacter)
    
    /// Checks if a character is marked as favorite.
    /// - Parameter characterId: The ID of the character.
    /// - Returns: `true` if the character is a favorite, otherwise `false`.
    func isFavorite(characterId: Int) -> Bool
    
    /// Updates the favorite status of a specific character.
    /// - Parameter character: The `MarvelCharacter` to be updated.
    func updateFavoriteStatus(for character: MarvelCharacter)
}

/// ViewModel responsible for handling character-related operations.
final class CharactersViewModel: CharactersViewModelProtocol {
    
    private let repository: CharactersServiceProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol
    weak var delegate: ViewModelDelegate?
    private let imageLoader: ImageLoaderProtocol
    
    internal var allCharacters: [MarvelCharacter] = []
    var filteredCharacters: [MarvelCharacter] = []
    private var characterIDs: Set<Int> = [] // Performance optimization
    
    private var offset = 0
    private let limit = 20
    private var hasMorePages = true
    private var isFetching = false
    private var lastSearchQuery = ""
    private var searchWorkItem: DispatchWorkItem?

    
    init(repository: CharactersServiceProtocol = CharactersService(),
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesManager.shared,
         imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
        self.repository = repository
        self.favoritesRepository = favoritesRepository
        self.imageLoader = imageLoader
    }
    
    /// Fetches characters, either from API or cache.
    /// - Parameter forceUpdate: If `true`, forces an API fetch.
    func fetchCharacters(forceUpdate: Bool = false) {
        guard !isFetching else { return }
        isFetching = true
        delegate?.didUpdateLoadingState(isLoading: true)
        
        repository.fetchCharacters(forceUpdate: forceUpdate) { [weak self] result in
            guard let self = self else {
                self?.delegate?.didUpdateLoadingState(isLoading: false)
                return
            }
            self.isFetching = false
            
            switch result {
            case .success(let characters):
                self.offset = characters.count
                self.hasMorePages = self.offset < 2873
                
                self.characterIDs.removeAll()
                let uniqueCharacters = characters.filter { self.characterIDs.insert($0.id).inserted }
                
                self.allCharacters = uniqueCharacters
                self.filteredCharacters = uniqueCharacters
                
                CacheManager.shared.saveCharacters(characters)
                self.delegate?.didUpdateData()
                self.delegate?.didUpdateLoadingState(isLoading: false)
                
            case .failure(let error):
                self.handleError(error)
                self.loadCachedCharacters()
                return
            }
        }
    }
    
    /// Loads additional characters for pagination.
    func loadMoreCharacters() {
        guard !isFetching, hasMorePages else { return }
        isFetching = true
        delegate?.didUpdateLoadingState(isLoading: true)
        
        repository.loadMoreCharacters { [weak self] result in
            guard let self = self else {
                self?.delegate?.didUpdateLoadingState(isLoading: false)
                return
            }
            self.isFetching = false
            
            switch result {
            case .success(let newCharacters):
                if newCharacters.isEmpty {
                    self.hasMorePages = false
                    self.delegate?.didUpdateLoadingState(isLoading: false)
                    return
                }
                
                let existingCharactersSet = Set(self.allCharacters)
                let uniqueNewCharacters = newCharacters.filter { !existingCharactersSet.contains($0) }
                
                self.allCharacters.append(contentsOf: uniqueNewCharacters)
                self.filteredCharacters.append(contentsOf: uniqueNewCharacters)
                
                self.offset += newCharacters.count
                
                CacheManager.shared.appendCharacters(uniqueNewCharacters)
                self.delegate?.didUpdateData()
                self.delegate?.didUpdateLoadingState(isLoading: false)

            case .failure(let error):
                self.handleError(error)
            }
            
        }
    }
    
    /// Searches for characters based on a given query.
    /// - Parameter query: The search keyword.
    func searchCharacter(with query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedQuery != lastSearchQuery else { return }
        lastSearchQuery = trimmedQuery
        
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.filteredCharacters = trimmedQuery.isEmpty
            ? self?.allCharacters ?? []
            : self?.allCharacters.filter { $0.name.lowercased().hasPrefix(trimmedQuery.lowercased()) } ?? []
            
            self?.delegate?.didUpdateData()
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
    
    /// Toggles the favorite status of a character.
    /// - Parameter character: The `MarvelCharacter` to be updated.
    func toggleFavorite(for character: MarvelCharacter) {
        favoritesRepository.addOrRemoveFavorite(character: character)
        
        if favoritesRepository.isFavorite(characterId: character.id),
           let imageUrl = character.thumbnail?.fullUrl {
            imageLoader.loadImage(from: imageUrl) { image in
                if let image = image {
                    CacheManager.shared.saveImage(image, for: imageUrl)
                }
            }
        } else if let imageUrl = character.thumbnail?.fullUrl {
            CacheManager.shared.deleteImage(for: imageUrl)
        }
        
        if filteredCharacters.contains(where: { $0.id == character.id }) {
            delegate?.didUpdateData()
        }
    }
    
    /// Updates the favorite status of a character.
    /// - Parameter character: The `MarvelCharacter` to be updated.
    func updateFavoriteStatus(for character: MarvelCharacter) {
        if let index = filteredCharacters.firstIndex(where: { $0.id == character.id }) {
            let updatedCharacter = MarvelCharacter(
                id: character.id,
                name: character.name,
                description: character.description,
                thumbnail: character.thumbnail
            )
            
            filteredCharacters[index] = updatedCharacter
            delegate?.didUpdateData()
        }
    }
    
    /// Checks if a character is marked as favorite.
    /// - Parameter characterId: The ID of the character.
    /// - Returns: `true` if the character is a favorite, otherwise `false`.
    func isFavorite(characterId: Int) -> Bool {
        return favoritesRepository.isFavorite(characterId: characterId)
    }
    
    /// Handles API errors and informs the delegate.
    private func handleError(_ error: APIError) {
        let errorMessage = ErrorManager.getMessage(for: error)
        self.delegate?.didUpdateLoadingState(isLoading: false)
        delegate?.didReceiveError(message: errorMessage)
    }
    
    /// Loads cached characters in case of an offline state.
    func loadCachedCharacters() {
        if let cachedCharacters = CacheManager.shared.loadCharacters() {
            self.allCharacters = cachedCharacters
            self.filteredCharacters = cachedCharacters
            self.delegate?.didUpdateData()
        }
    }
}
