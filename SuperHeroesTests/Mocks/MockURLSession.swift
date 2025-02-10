//
//  MockURLSession.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

// MARK: - Mock URLSession
class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var mockActiveTasks: [URL: MockURLSessionDataTask] = [:]
    var invalidURL: Bool = false // 🔥 Novo flag para simular erro de URL inválida

    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        print("🔥 MockURLSession chamada - Retornando erro de URL inválida")
        
        if self.invalidURL {  // 🔥 Se for para simular URL inválida
            print("❌ [DEBUG] Simulando erro de URL inválida")
            completionHandler(nil, nil, APIError.invalidURL)
            return MockURLSessionDataTask {}
        }
        
        if let error = self.mockError {
            print("⚠️ [DEBUG] Simulando erro: \(error)")
            completionHandler(nil, nil, error)
            return MockURLSessionDataTask {}
        }
        
        completionHandler(self.mockData, self.mockResponse, nil)
        return MockURLSessionDataTask {}
    }
    
    func cancelTask(for url: URL) {
        mockActiveTasks[url]?.cancel()
        mockActiveTasks[url] = nil // 🔥 Remove corretamente
    }
}

/// Simulação de uma `URLSessionDataTask` sem fazer chamadas reais
class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    private var isCancelled = false
    
    init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            guard !isCancelled else { return }
            closure()
        }

        override func cancel() {
            isCancelled = true
        }
}

// MARK: - Mock NetworkMonitor
class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true

    func isInternetAvailable() -> Bool {
        return isConnected
    }
}

// MARK: - Mock SecureConstants
struct MockSecureConstants {
    static let baseURL = "https://gateway.marvel.com/v1/public/"
    static let publicKey = "testPublicKey"
    static let privateKey = "testPrivateKey"
}

// MARK: - Mock HashHelper
class MockHashHelper {
    static func generateMD5(from input: String) -> String {
        return "mockedHash"
    }
}
