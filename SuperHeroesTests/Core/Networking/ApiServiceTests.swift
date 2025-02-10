//
//  ApiServiceTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class ApiServiceTests: XCTestCase {

    var apiService: ApiService!
    var mockSession: MockURLSession!
    var mockNetworkMonitor: MockNetworkMonitor!
    var mockApiService: MockApiService!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockNetworkMonitor = MockNetworkMonitor()
        apiService = ApiService(session: mockSession, networkMonitor: mockNetworkMonitor)
        mockApiService = MockApiService()
    }

    override func tearDown() {
        apiService = nil
        mockSession = nil
        mockNetworkMonitor = nil
        mockApiService = nil
        super.tearDown()
    }

    // ✅ Teste de Sucesso
    func testFetchCharacters_Success_ShouldReturnCharacters() {
        let expectation = XCTestExpectation(description: "Deve retornar personagens")

        let mockCharacter = MarvelCharacter(id: 1, name: "Spider-Man", description: "Hero", thumbnail: nil)
        let mockResponse = CharacterDataWrapper(
            code: 200,
            status: "OK",
            data: CharacterDataContainer(offset: 0, limit: 20, total: 100, count: 1, results: [mockCharacter])
        )

        let jsonData = try! JSONEncoder().encode(mockResponse)
        mockSession.mockData = jsonData
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: MockSecureConstants.baseURL)!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        apiService.fetchCharacters(offset: 0, limit: 20) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.data.results.count, 1)
                XCTAssertEqual(response.data.results.first?.name, "Spider-Man")
                expectation.fulfill()
            case .failure:
                XCTFail("A API deveria retornar sucesso")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }

    // ❌ Teste de Erro de Rede
    func testFetchCharacters_NoInternet_ShouldReturnNetworkError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de rede")

        mockNetworkMonitor.isConnected = false

        apiService.fetchCharacters(offset: 0, limit: 20) { result in
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

    // ❌ Teste de URL Inválida
    func testFetchCharacters_InvalidURL_ShouldReturnInvalidURLError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de URL inválida")

        mockApiService.forceInvalidURL = true

        mockApiService.fetchCharacters(offset: 0, limit: 20) { result in
            switch result {
            case .failure(let error):
                if case .invalidURL = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Erro incorreto. Esperado: invalidURL, Recebido: \(error)")
                }
            case .success:
                XCTFail("A API não deveria ter sucesso")
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    // ❌ Teste de Decodificação (Resposta Inválida)
    func testFetchCharacters_InvalidJSON_ShouldReturnDecodingError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de decodificação")

        mockSession.mockData = "INVALID DATA".data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: MockSecureConstants.baseURL)!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        apiService.fetchCharacters(offset: 0, limit: 20) { result in
            switch result {
            case .failure(let error):
                if case .decodingError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Deveria retornar erro de decodificação")
                }
            case .success:
                XCTFail("A API não deveria ter sucesso")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }

    // ❌ Teste de Rate Limit Exceeded (429)
    func testFetchCharacters_RateLimit_ShouldReturnRateLimitError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de rate limit")

        mockSession.mockResponse = HTTPURLResponse(url: URL(string: MockSecureConstants.baseURL)!,
                                                   statusCode: 429,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        apiService.fetchCharacters(offset: 0, limit: 20) { result in
            switch result {
            case .failure(let error):
                if case .rateLimitExceeded = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Deveria retornar erro de rate limit")
                }
            case .success:
                XCTFail("A API não deveria ter sucesso")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }

    // ❌ Teste de Erro Genérico do Servidor
    func testFetchCharacters_ServerError_ShouldReturnServerError() {
        let expectation = XCTestExpectation(description: "Deve retornar erro de servidor")

        mockSession.mockResponse = HTTPURLResponse(url: URL(string: MockSecureConstants.baseURL)!,
                                                   statusCode: 500,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        apiService.fetchCharacters(offset: 0, limit: 20) { result in
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
