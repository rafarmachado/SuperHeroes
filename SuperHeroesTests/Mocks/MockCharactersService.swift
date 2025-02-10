//
//  MockCharactersService.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class MockCharactersService: CharactersServiceProtocol {
    var shouldReturnError = false
    var mockResponse: [MarvelCharacter] = []

    func fetchCharacters(forceUpdate: Bool, completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.serverError(500)))
        } else {
            completion(.success(mockResponse))
        }
    }
    
    func loadMoreCharacters(completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.serverError(500)))
        } else {
            completion(.success(mockResponse))
        }
    }
}
