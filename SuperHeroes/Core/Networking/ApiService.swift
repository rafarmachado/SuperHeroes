//
//  ApiService.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import Foundation

// MARK: - Protocol for Mocking and Dependency Injection
protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: - API Service Protocol
protocol ApiServiceProtocol {
    func fetchCharacters(offset: Int,
                         limit: Int,
                         completion: @escaping (Result<CharacterDataWrapper, APIError>) -> Void)
}

// MARK: - API Service Implementation
final class ApiService: ApiServiceProtocol {
    static let shared: ApiServiceProtocol = ApiService()

    var session: URLSessionProtocol
    var baseURL: String
    var publicKey: String
    var privateKey: String?
    var networkMonitor: NetworkMonitorProtocol
    
    var isFetching = false // Prevents concurrent API requests

    init(session: URLSessionProtocol = URLSession.shared,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared) {
        self.session = session
        self.networkMonitor = networkMonitor
        self.baseURL = SecureConstants.baseURL
        self.publicKey = SecureConstants.publicKey
        self.privateKey = SecureConstants.privateKey
    }

    // MARK: - Fetch Characters

    /// Fetches a list of Marvel characters with pagination.
    /// - Parameters:
    ///   - offset: The starting index for pagination.
    ///   - limit: The maximum number of characters to fetch.
    ///   - completion: A closure that returns a `Result` with either `CharacterDataWrapper` or an `APIError`.
    func fetchCharacters(offset: Int = 0,
                         limit: Int = 100,
                         completion: @escaping (Result<CharacterDataWrapper, APIError>) -> Void) {
        guard !isFetching else { return } // Prevents multiple simultaneous requests
        isFetching = true

        if !networkMonitor.isInternetAvailable() {
            completion(.failure(.networkError(NSError(domain: "No Internet", code: -1009, userInfo: nil))))
            isFetching = false
            return
        }

        let endpoint = "characters"
        let queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        guard let url = createAuthenticatedURL(endpoint: endpoint, queryItems: queryItems) else {
            completion(.failure(.invalidURL))
            isFetching = false
            return
        }

        var request = URLRequest(url: url)
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.isFetching = false } // Ensures request control is released

            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(CharacterDataWrapper.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }

            case 429:
                completion(.failure(.rateLimitExceeded))

            default:
                completion(.failure(.serverError(httpResponse.statusCode)))
            }
        }

        task.resume()
    }

    // MARK: - Authentication URL Generator

    /// Generates a fully authenticated URL for Marvel API requests.
    /// - Parameters:
    ///   - endpoint: The API endpoint (e.g., `"characters"`).
    ///   - queryItems: Optional query parameters.
    /// - Returns: A complete `URL` with authentication parameters.
    private func createAuthenticatedURL(endpoint: String, queryItems: [URLQueryItem] = []) -> URL? {
        guard let privateKey = privateKey else {
            return nil
        }

        let ts = "\(Date().timeIntervalSince1970)"
        let hash = HashHelper.generateMD5(from: "\(ts)\(privateKey)\(publicKey)")

        var components = URLComponents(string: baseURL + endpoint)
        components?.queryItems = queryItems + [
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: hash)
        ]

        return components?.url
    }
}
