//
//  CharactersServiceTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//
//
//  CharactersServiceTests.swift
//  SuperHeroesTests
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class CharactersServiceTests: XCTestCase {
    
    var service: CharactersService!
    var mockApiService: MockApiService!
    var mockCacheManager: MockCacheManager!
    
    override func setUp() {
        super.setUp()
        mockApiService = MockApiService()
        mockCacheManager = MockCacheManager()
        
        // Intercepta chamadas para CacheManager.shared
        CacheManagerMockInterceptor.shared = mockCacheManager
        
        service = CharactersService(apiService: mockApiService)
    }
    
    override func tearDown() {
        service = nil
        mockApiService = nil
        mockCacheManager = nil
        super.tearDown()
    }
    
    // ✅ Teste de sucesso: Fetch Characters
    func testFetchCharacters_Success_ShouldReturnCharacters() {
        let expectation = XCTestExpectation(description: "Deve retornar uma lista de personagens")

        let mockCharacters = [
            MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil),
            MarvelCharacter(id: 2, name: "Iron Man", description: "Genius Billionaire", thumbnail: nil)
        ]

        mockApiService.mockResult = .success(CharacterDataWrapper(
            code: 200,
            status: "OK",
            data: CharacterDataContainer(offset: 0, limit: 20, total: 100, count: 2, results: mockCharacters)
        ))

        service.fetchCharacters(forceUpdate: false) { result in
            if case .success(let characters) = result {
                XCTAssertEqual(characters.count, 2)
            } else {
                XCTFail("A API deveria retornar sucesso")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
    
    // ❌ Teste de erro de rede
    func testFetchCharacters_NoInternet_ShouldReturnNetworkError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de rede")
        
        mockApiService.mockResult = .failure(.networkError(NSError(domain: "No Internet", code: -1009, userInfo: nil)))
        
        service.fetchCharacters(forceUpdate: false) { result in
            switch result {
            case .failure(let error):
                if case .networkError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Deveria retornar erro de rede")
                }
            case .success:
                XCTFail("A API não deveria ter sucesso")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    // ✅ Teste de sucesso: Load More Characters (Paginação)
    func testLoadMoreCharacters_Success_ShouldAppendCharacters() {
        let expectation = XCTestExpectation(description: "Deve adicionar mais personagens")

        let mockNewCharacters = [
            MarvelCharacter(id: 3, name: "Thor", description: "God of Thunder", thumbnail: nil),
            MarvelCharacter(id: 4, name: "Hulk", description: "Strongest Avenger", thumbnail: nil)
        ]

        mockApiService.mockResult = .success(CharacterDataWrapper(
            code: 200,
            status: "OK",
            data: CharacterDataContainer(offset: 20, limit: 20, total: 100, count: 2, results: mockNewCharacters)
        ))

        service.loadMoreCharacters { result in
            if case .success(let characters) = result {
                XCTAssertEqual(characters.count, 2)
            } else {
                XCTFail("A API deveria retornar sucesso")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
    
    // ❌ Teste de nenhum novo personagem (fim da lista)
    func testLoadMoreCharacters_NoMoreCharacters_ShouldStopPagination() {
        let expectation = XCTestExpectation(description: "Não deve carregar mais personagens")
        
        mockApiService.mockResult = .success(CharacterDataWrapper(
            code: 200,
            status: "OK",
            data: CharacterDataContainer(offset: 20, limit: 20, total: 100, count: 0, results: [])
        ))
        
        service.loadMoreCharacters { result in
            switch result {
            case .success(let characters):
                XCTAssertEqual(characters.count, 0, "Não deveria adicionar mais personagens")
                expectation.fulfill()
            case .failure:
                XCTFail("A API deveria retornar uma lista vazia, não um erro")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    // ❌ Teste de erro de servidor
    func testLoadMoreCharacters_ServerError_ShouldReturnServerError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de servidor")
        
        mockApiService.mockResult = .failure(.serverError(500))
        
        service.loadMoreCharacters { result in
            switch result {
            case .failure(let error):
                if case .serverError(let statusCode) = error, statusCode == 500 {
                    expectation.fulfill()
                } else {
                    XCTFail("Deveria retornar erro de servidor 500")
                }
            case .success:
                XCTFail("A API não deveria ter sucesso")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
