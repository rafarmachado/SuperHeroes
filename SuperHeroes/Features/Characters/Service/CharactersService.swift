//
//  CharactersService.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import Foundation

/// Protocol defining the contract for fetching characters from the API.
public protocol CharactersServiceProtocol {
    /// Fetches a list of Marvel characters, with an optional forced update.
    func fetchCharacters(forceUpdate: Bool, completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void)
    
    /// Loads additional characters (pagination).
    func loadMoreCharacters(completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void)
}

/// Handles character retrieval from the Marvel API, including caching and pagination.
final class CharactersService: CharactersServiceProtocol {
    
    private let apiService: ApiServiceProtocol
    private let cacheManager: CacheManager
    
    private var offset = 0
    private let limit = 20 // Loads 20 characters per request
    private var isFetching = false
    private var hasMorePages = true
    
    /// Initializes the service with an API service and a cache manager.
    init(apiService: ApiServiceProtocol = ApiService.shared,
         cacheManager: CacheManager = .shared) {
        self.apiService = apiService
        self.cacheManager = cacheManager
    }
    
    // MARK: - Fetch Characters
    
    /// Fetches Marvel characters from the API, either from cache or a fresh request.
    ///
    /// - Parameters:
    ///   - forceUpdate: If `true`, bypasses the cache and fetches fresh data.
    ///   - completion: Closure returning a `Result` with either a list of characters or an error.
    func fetchCharacters(forceUpdate: Bool = false, completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        
        apiService.fetchCharacters(offset: 0, limit: limit) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let response):
                let characters = response.data.results
                self.offset = characters.count
                self.hasMorePages = self.offset < response.data.total
                
                // Updates cache with the newly fetched characters
                self.cacheManager.saveCharacters(characters)
                
                completion(.success(characters))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Load More Characters (Pagination)
    
    /// Loads more characters for pagination, fetching additional batches from the API.
    ///
    /// - Parameter completion: Closure returning a `Result` with either a list of new characters or an error.
    func loadMoreCharacters(completion: @escaping (Result<[MarvelCharacter], APIError>) -> Void) {
        guard !isFetching, hasMorePages else { return }
        isFetching = true
        
        apiService.fetchCharacters(offset: offset, limit: limit) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                let newCharacters = response.data.results
                
                if newCharacters.isEmpty {
                    self.hasMorePages = false
                    completion(.success([]))
                    return
                }
                
                // Updates the offset only if new characters were retrieved
                self.offset += newCharacters.count
                self.hasMorePages = self.offset < response.data.total
                
                // Appends new characters to the cache without overwriting existing ones
                self.cacheManager.appendCharacters(newCharacters)
                
                completion(.success(newCharacters))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
