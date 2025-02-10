//
//  CacheManagerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class CacheManagerTests: XCTestCase {
    
    var cacheManager: CacheManager!
    let testCharacter = MarvelCharacter(id: 1, name: "Iron Man", description: "Genius billionaire playboy philanthropist", thumbnail: nil)
    let testImageURL = "https://example.com/image.png"
    let testImage = UIImage(systemName: "star.fill")!
    
    override func setUp() {
        super.setUp()
        cacheManager = CacheManager.shared
        cacheManager.clearCache()
        cacheManager.clearCacheImage()
    }
    
    override func tearDown() {
        cacheManager.clearCache()
        cacheManager.clearCacheImage()
        super.tearDown()
    }
    
    func testSaveAndLoadCharacters() {
        let characters = [testCharacter]
        cacheManager.saveCharacters(characters)
        
        let loadedCharacters = cacheManager.loadCharacters()
        XCTAssertNotNil(loadedCharacters)
        XCTAssertEqual(loadedCharacters?.count, 1)
        XCTAssertEqual(loadedCharacters?.first?.name, "Iron Man")
    }
    
    func testAppendCharacters() {
        let characters = [testCharacter]
        cacheManager.saveCharacters(characters)
        
        let newCharacter = MarvelCharacter(id: 2, name: "Captain America", description: "Super Soldier", thumbnail: nil)
        cacheManager.appendCharacters([newCharacter])
        
        let loadedCharacters = cacheManager.loadCharacters()
        XCTAssertNotNil(loadedCharacters)
        XCTAssertEqual(loadedCharacters?.count, 2)
    }
    
    func testAppendCharactersAvoidsDuplicates() {
        let characters = [testCharacter]
        cacheManager.saveCharacters(characters)
        
        // Tentando adicionar o mesmo personagem novamente
        cacheManager.appendCharacters([testCharacter])
        
        let loadedCharacters = cacheManager.loadCharacters()
        XCTAssertNotNil(loadedCharacters)
        XCTAssertEqual(loadedCharacters?.count, 1) // Não deve duplicar
    }
    
    func testClearCache() {
        cacheManager.saveCharacters([testCharacter])
        cacheManager.clearCache()
        let loadedCharacters = cacheManager.loadCharacters()
        XCTAssertNil(loadedCharacters)
    }
    
    func testSaveAndLoadImage() {
        cacheManager.saveImage(testImage, for: testImageURL)
        
        let loadedImage = cacheManager.loadImage(for: testImageURL)
        XCTAssertNotNil(loadedImage)
    }
    
    func testDeleteImage() {
        cacheManager.saveImage(testImage, for: testImageURL)
        cacheManager.deleteImage(for: testImageURL)
        
        let loadedImage = cacheManager.loadImage(for: testImageURL)
        XCTAssertNil(loadedImage)
    }
    
    func testClearCacheImage() {
        cacheManager.saveImage(testImage, for: testImageURL)
        cacheManager.clearCacheImage()
        
        let loadedImage = cacheManager.loadImage(for: testImageURL)
        XCTAssertNil(loadedImage)
    }
    
    func testCacheManager_SaveAndLoadImage() {
        let mockImage = UIImage(systemName: "star")!
        let cacheKey = "http://fakeurl.com/image.jpg"
        
        CacheManager.shared.saveImage(mockImage, for: cacheKey)
        let retrievedImage = CacheManager.shared.loadImage(for: cacheKey)

        XCTAssertNotNil(retrievedImage, "A imagem deveria ser recuperada corretamente do cache.")
    }
}
