//
//  CharacterDetailViewModel.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// Protocol defining the contract for the Character Detail ViewModel.
protocol CharacterDetailViewModelProtocol {
    /// The character being displayed.
    var character: MarvelCharacter { get }
    
    /// Closure triggered when the character's image is loaded.
    var onImageLoaded: ((UIImage?) -> Void)? { get set }
    
    /// Closure triggered when the loading state changes.
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    
    /// Closure triggered when the favorite state changes.
    var onFavoriteStateChanged: ((Bool) -> Void)? { get set }
    
    /// Closure triggered when an error occurs.
    var onError: ((String) -> Void)? { get set }

    /// Loads the character's image data.
    func loadCharacterData()
    
    /// Checks if the character is marked as favorite.
    func isCharacterFavorite() -> Bool
    
    /// Toggles the character's favorite status.
    func toggleFavorite()
}

/// ViewModel responsible for managing character details.
final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    // MARK: - Properties
    
    /// Image loader used to fetch character images.
    private let imageLoader: ImageLoader
    
    /// Repository responsible for managing favorites.
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    /// The character being displayed.
    let character: MarvelCharacter

    var onImageLoaded: ((UIImage?) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onFavoriteStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Initialization
    
    /**
     Initializes the ViewModel with a character, image loader, and favorites repository.
     
     - Parameters:
        - character: The Marvel character to display.
        - imageLoader: The image loader service (default: `ImageLoader.shared`).
        - favoritesRepository: The favorites repository (default: `FavoritesManager.shared`).
     */
    init(character: MarvelCharacter,
         imageLoader: ImageLoader = ImageLoader.shared,
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesManager.shared) {
        self.character = character
        self.imageLoader = imageLoader
        self.favoritesRepository = favoritesRepository
    }

    // MARK: - Character Image Handling
    
    /**
     Loads the character's image from cache or downloads it if necessary.
     If the character is a favorite, the image is cached for future use.
     */
    func loadCharacterData() {
        guard let imageUrl = character.thumbnail?.fullUrl else {
            onError?("URL da imagem inválida.")
            return
        }

        // Attempts to load from cache if the character is a favorite.
        if isCharacterFavorite(),
           let cachedImage = CacheManager.shared.loadImage(for: imageUrl) {
            onImageLoaded?(cachedImage)
            return
        }

        // If not in cache, downloads the image.
        onLoadingStateChanged?(true)
        imageLoader.loadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            self.onLoadingStateChanged?(false)
            
            // Caches the image if the character is a favorite.
            if let image = image, self.isCharacterFavorite() {
                CacheManager.shared.saveImage(image, for: imageUrl)
            }
            self.onImageLoaded?(image)
        }
    }
    
    // MARK: - Favorite Management
    
    /**
     Checks if the character is currently marked as a favorite.
     
     - Returns: `true` if the character is a favorite, otherwise `false`.
     */
    func isCharacterFavorite() -> Bool {
        favoritesRepository.isFavorite(characterId: character.id)
    }

    /**
     Toggles the favorite status of the character.
     If the character is removed from favorites, its cached image is deleted.
     */
    func toggleFavorite() {
        favoritesRepository.addOrRemoveFavorite(character: character)
        onFavoriteStateChanged?(isCharacterFavorite())

        // Removes cached image if the character is unfavorited.
        if !isCharacterFavorite(), let imageUrl = character.thumbnail?.fullUrl {
            CacheManager.shared.deleteImage(for: imageUrl)
        }
    }
}
