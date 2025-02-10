//
//  FavoritesViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// Protocol defining the contract for managing favorite characters.
protocol FavoritesViewModelProtocol {
    
    /// List of favorite characters.
    var favoriteCharacters: [MarvelCharacter] { get }
    
    /// Delegate to communicate updates to the UI.
    var delegate: ViewModelDelegate? { get set }
    
    /// Fetches the list of favorite characters.
    func fetchFavorites()
    
    /// Toggles the favorite status of a character.
    func toggleFavorite(for character: MarvelCharacter)
    
    /// Checks if a character is marked as favorite.
    func isFavorite(characterId: Int) -> Bool
    
    /// Loads an image for a character.
    func loadImage(for character: MarvelCharacter, completion: @escaping (UIImage?) -> Void)
}

/// ViewModel responsible for handling favorite characters logic.
final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    // MARK: - Properties
    
    /// Repository responsible for managing favorites.
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    /// Delegate to notify UI updates.
    weak var delegate: ViewModelDelegate?
    
    /// Service responsible for loading images.
    private let imageLoader: ImageLoaderProtocol
    
    /// List of favorite characters.
    private(set) var favoriteCharacters: [MarvelCharacter] = []
    
    // MARK: - Initialization
    
    /**
     Initializes the ViewModel with a favorites repository and image loader.
     
     - Parameters:
        - favoritesRepository: The repository handling favorite characters.
        - imageLoader: The service responsible for fetching images.
     */
    init(favoritesRepository: FavoritesRepositoryProtocol = FavoritesManager.shared,
         imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
        self.favoritesRepository = favoritesRepository
        self.imageLoader = imageLoader
    }
    
    // MARK: - Favorite Characters Management
    
    /// Fetches favorite characters and updates the UI.
    func fetchFavorites() {
        delegate?.didUpdateLoadingState(isLoading: true)

        let favorites = favoritesRepository.getFavorites()
        
        DispatchQueue.main.async {
            self.favoriteCharacters = favorites
            self.delegate?.didUpdateData()
            self.delegate?.didUpdateLoadingState(isLoading: false)

            if favorites.isEmpty {
                self.delegate?.didReceiveError(message: "Nenhum personagem favoritado ainda.")
            }
        }
    }
    
    /**
     Toggles the favorite status of a character without reloading the entire table.
     
     - Parameter character: The character to toggle.
     */
    func toggleFavorite(for character: MarvelCharacter) {
        favoritesRepository.addOrRemoveFavorite(character: character)

        if let index = favoriteCharacters.firstIndex(where: { $0.id == character.id }) {
            favoriteCharacters.remove(at: index) // Removes if already favorited.
        } else {
            favoriteCharacters.append(character) // Adds if not in the list.
        }
        
        delegate?.didUpdateData()
    }
    
    /**
     Checks if a character is marked as a favorite.
     
     - Parameter characterId: The ID of the character.
     - Returns: `true` if the character is a favorite, otherwise `false`.
     */
    func isFavorite(characterId: Int) -> Bool {
        return favoritesRepository.isFavorite(characterId: characterId)
    }

    // MARK: - Image Loading
    
    /**
     Loads the character's image, prioritizing the cache before fetching from the network.
     
     - Parameters:
        - character: The character whose image should be loaded.
        - completion: Closure returning the loaded image or a placeholder.
     */
    func loadImage(for character: MarvelCharacter, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = character.thumbnail?.fullUrl else {
            completion(UIImage(named: "placeholder"))
            return
        }

        // Attempts to load the image from cache first.
        if let cachedImage = CacheManager.shared.loadImage(for: imageUrl) {
            completion(cachedImage)
            return
        }

        // If not in cache, downloads and saves it for future use.
        imageLoader.loadImage(from: imageUrl) { image in
            if let image = image {
                CacheManager.shared.saveImage(image, for: imageUrl)
            }
            completion(image)
        }
    }
}
