//
//  ApiError.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

public enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Error)
    case rateLimitExceeded
    case serverError(Int)
}
