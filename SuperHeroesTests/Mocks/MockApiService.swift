//
//  MockApiService.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import Foundation
import XCTest
@testable import SuperHeroes

final class MockApiService: ApiServiceProtocol {
    var mockResult: Result<CharacterDataWrapper, APIError>?
    var forceInvalidURL: Bool = false

    
    func fetchCharacters(offset: Int, limit: Int, completion: @escaping (Result<CharacterDataWrapper, APIError>) -> Void) {
        if forceInvalidURL {
            completion(.failure(.invalidURL))
            return
        }
        
        if let result = mockResult {
            completion(result)
        }
    }
}
