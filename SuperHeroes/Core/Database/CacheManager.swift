//
//  CacheManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 04/02/25.
//

import Foundation
import UIKit

/// Singleton responsible for caching characters and images to improve performance and reduce API requests.
final class CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
    
    private let cacheKey = "cachedCharacters"
    private let fileManager = FileManager.default

    // MARK: - Character Caching

    /// Saves a list of characters to UserDefaults for caching.
    /// - Parameter characters: The list of characters to be cached.
    func saveCharacters(_ characters: [MarvelCharacter]) {
        do {
            let data = try JSONEncoder().encode(characters)
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            print("Error saving cache: \(error.localizedDescription)")
        }
    }
    
    /// Appends new characters to the existing cache while ensuring no duplicates.
    /// - Parameter newCharacters: The new characters to be added to the cache.
    func appendCharacters(_ newCharacters: [MarvelCharacter]) {
        var allCharacters = self.loadCharacters() ?? []
        
        let existingCharactersSet = Set(allCharacters)
        let uniqueCharacters = newCharacters.filter { !existingCharactersSet.contains($0) }

        allCharacters.append(contentsOf: uniqueCharacters)

        do {
            let data = try JSONEncoder().encode(allCharacters)
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            print("Error saving cache: \(error.localizedDescription)")
        }
    }
    
    /// Loads cached characters from UserDefaults.
    /// - Returns: An optional array of `MarvelCharacter` if cache exists, otherwise nil.
    func loadCharacters() -> [MarvelCharacter]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        
        do {
            return try JSONDecoder().decode([MarvelCharacter].self, from: data)
        } catch {
            print("Error loading cache: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Clears the character cache stored in UserDefaults.
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
    
    // MARK: - Image Caching

    /// Saves an image to the local file system cache.
    /// - Parameters:
    ///   - image: The image to be cached.
    ///   - url: The URL string used as the file identifier.
    func saveImage(_ image: UIImage, for url: String) {
        guard let data = image.pngData() else { return }
        let fileURL = getFilePath(for: url)

        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image to cache: \(error.localizedDescription)")
        }
    }
    
    /// Loads an image from the local file system cache.
    /// - Parameter url: The URL string used to retrieve the cached image.
    /// - Returns: An optional `UIImage` if the image exists in the cache.
    func loadImage(for url: String) -> UIImage? {
        let fileURL = getFilePath(for: url)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

    /// Deletes an image from the local file system cache.
    /// - Parameter url: The URL string used as the file identifier.
    func deleteImage(for url: String) {
        let fileURL = getFilePath(for: url)
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                print("Error removing image from cache: \(error.localizedDescription)")
            }
        }
    }
    
    /// Clears all images stored in the cache directory.
    func clearCacheImage() {
        let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print("Error clearing image cache: \(error.localizedDescription)")
        }
    }

    // MARK: - File Management

    /// Generates a valid file path for caching an image.
    /// - Parameter url: The URL string used to generate the file path.
    /// - Returns: The `URL` path for storing the image.
    private func getFilePath(for url: String) -> URL {
        let fileName = url
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_") // Normalizes file name
        let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(fileName)
    }
}
