//
//  Untitled.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import Foundation
@testable import SuperHeroes

final class MockCharactersService: CharactersServiceProtocol {
    
    var shouldFail = false
  
    func fetchCharacters(forceUpdate: Bool, completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void) {
        if shouldFail {
            completion(.failure(.networkError(NSError(domain: "No Internet", code: -1009, userInfo: nil))))
        } else {
            completion(.success(MockCharactersService.mockCharacters()))
        }
    }
    
    func loadMoreCharacters(completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void) {
        completion(.success(MockCharactersService.mockCharacters()))
    }
    
    static func mockCharacters() -> [MarvelCharacter] {
        return [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Friendly neighborhood hero", thumbnail: nil),
            MarvelCharacter(id: 2, name: "Iron Man", description: "Genius billionaire playboy philanthropist", thumbnail: nil),
            MarvelCharacter(id: 3, name: "Hulk", description: "The strongest Avenger", thumbnail: nil)
        ]
    }
}
