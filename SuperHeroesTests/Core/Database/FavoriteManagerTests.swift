//
//  FavoriteManagerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        favoritesManager = FavoritesManager(coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        favoritesManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testAddFavorite_ShouldStoreCharacter() {
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        
        favoritesManager.addOrRemoveFavorite(character: character)
        
        let results: [FavoriteCharacter] = mockCoreDataManager.fetchObjects(ofType: FavoriteCharacter.self)
        XCTAssertEqual(results.count, 1, "Character should be added to favorites")
    }
    
    func testRemoveFavorite_ShouldDeleteCharacter() {
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        favoritesManager.addOrRemoveFavorite(character: character)
        
        favoritesManager.addOrRemoveFavorite(character: character)

        let results: [FavoriteCharacter] = mockCoreDataManager.fetchObjects(ofType: FavoriteCharacter.self)
        XCTAssertTrue(results.isEmpty, "Character should be removed from favorites")
    }
    
    func testIsFavorite_ShouldReturnTrueForFavoriteCharacter() {
        let character = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        favoritesManager.addOrRemoveFavorite(character: character)
        
        XCTAssertTrue(favoritesManager.isFavorite(characterId: 1), "Character should be recognized as favorite")
    }
    
    func testClearFavorites_ShouldRemoveAllFavorites() {
        favoritesManager.addOrRemoveFavorite(character: MarvelCharacter(id: 1, name: "Iron Man", description: "Genius Billionaire", thumbnail: nil))
        favoritesManager.addOrRemoveFavorite(character: MarvelCharacter(id: 2, name: "Thor", description: "God of Thunder", thumbnail: nil))
        
        favoritesManager.clearFavorites()

        let results: [FavoriteCharacter] = mockCoreDataManager.fetchObjects(ofType: FavoriteCharacter.self)
        XCTAssertTrue(results.isEmpty, "All favorites should be removed")
    }
}
