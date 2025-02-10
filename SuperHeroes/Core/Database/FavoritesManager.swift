//
//  FavoritesManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import CoreData
import UIKit

/// Manages favorite characters using Core Data.
final class FavoritesManager: FavoritesRepositoryProtocol {
    
    static let shared = FavoritesManager()
    weak var delegate: FavoritesManagerDelegate?
    
    private let coreDataManager: CoreDataManagerProtocol
    
    /// Initializes the FavoritesManager with an optional Core Data manager.
    /// - Parameter coreDataManager: A `CoreDataManagerProtocol` instance, allowing for dependency injection.
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Retrieve Favorites

    /// Retrieves all favorite characters stored in Core Data.
    /// - Returns: An array of `MarvelCharacter` representing the user's favorites.
    func getFavorites() -> [MarvelCharacter] {
        let favorites: [FavoriteCharacter] = coreDataManager.fetchObjects(ofType: FavoriteCharacter.self)
        
        return favorites.map { favorite in
            MarvelCharacter(
                id: Int(favorite.id),
                name: favorite.name ?? "Unknown",
                description: favorite.desc ?? "No description available",
                thumbnail: Thumbnail(path: favorite.imageUrl ?? "", fileExtension: "")
            )
        }
        .sorted(by: { $0.name.lowercased() < $1.name.lowercased() }) // Keeps the list sorted alphabetically
    }
    
    // MARK: - Add or Remove Favorites

    /// Adds or removes a character from the favorites list, handling image caching.
    /// - Parameter character: The `MarvelCharacter` to be added or removed.
    func addOrRemoveFavorite(character: MarvelCharacter) {
        let predicate = NSPredicate(format: "id == %d", character.id)
        let existingFavorites: [FavoriteCharacter] = coreDataManager.fetchObjects(ofType: FavoriteCharacter.self, predicate: predicate)
        
        if let existingFavorite = existingFavorites.first {
            // Remove character from Core Data and cache
            coreDataManager.deleteObject(existingFavorite)
            CacheManager.shared.deleteImage(for: character.thumbnail?.fullUrl ?? "")
        } else {
            let newFavorite = FavoriteCharacter(context: coreDataManager.viewContext)
            newFavorite.id = Int64(character.id)
            newFavorite.name = character.name
            newFavorite.desc = character.description
            newFavorite.imageUrl = character.thumbnail?.fullUrl ?? ""
            
            // Download and store the favorite's image in the cache
            if let imageUrl = character.thumbnail?.fullUrl {
                ImageLoader.shared.loadImage(from: imageUrl) { image in
                    if let image = image {
                        CacheManager.shared.saveImage(image, for: imageUrl)
                    }
                }
            }
        }
        
        do {
            try coreDataManager.saveContext()
            delegate?.didUpdateFavorites()
        } catch {
            print("Error adding/removing favorite: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Check Favorite Status

    /// Checks whether a character is marked as a favorite.
    /// - Parameter characterId: The ID of the character.
    /// - Returns: `true` if the character is a favorite, otherwise `false`.
    func isFavorite(characterId: Int) -> Bool {
        let predicate = NSPredicate(format: "id == %d", characterId)
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            return try coreDataManager.viewContext.count(for: fetchRequest) > 0
        } catch {
            print("Error checking favorite status: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Clear All Favorites

    /// Removes all favorite characters and clears cached images.
    func clearFavorites() {
        let favorites: [FavoriteCharacter] = coreDataManager.fetchObjects(ofType: FavoriteCharacter.self)
        
        for favorite in favorites {
            if let imageUrl = favorite.imageUrl {
                CacheManager.shared.deleteImage(for: imageUrl) // Remove images from cache
            }
            coreDataManager.deleteObject(favorite) // Remove from Core Data
        }
        
        do {
            try coreDataManager.saveContext()
            delegate?.didUpdateFavorites()
        } catch {
            print("Error clearing favorites: \(error.localizedDescription)")
        }
    }
}
