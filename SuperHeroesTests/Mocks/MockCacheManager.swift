//
//  MockCacheManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import UIKit
import XCTest
@testable import SuperHeroes

final class CacheManagerMockInterceptor {
    static var shared: MockCacheManager = MockCacheManager()
}

final class MockCacheManager {
    private var imageCache: [String: UIImage] = [:]
    private(set)  var characterCache: [MarvelCharacter] = []
    private(set) var appendedCharacters: [MarvelCharacter] = []

    // ✅ Mock de armazenamento de personagens
    func saveCharacters(_ characters: [MarvelCharacter]) {
        characterCache = characters
    }

    func loadCharacters() -> [MarvelCharacter]? {
        return characterCache.isEmpty ? nil : characterCache
    }
    
    func appendCharacters(_ newCharacters: [MarvelCharacter]) {
        appendedCharacters.append(contentsOf: newCharacters)
    }

    func clearCache() {
        characterCache.removeAll()
        imageCache.removeAll()
        appendedCharacters.removeAll()
    }

    // ✅ Mock de armazenamento de imagens
    func saveImage(_ image: UIImage, for url: String) {
        imageCache[url] = image
    }

    func loadImage(for url: String) -> UIImage? {
        return imageCache[url]
    }

    func deleteImage(for url: String) {
        imageCache.removeValue(forKey: url)
    }

    func clearCacheImage() {
        imageCache.removeAll()
    }
}
