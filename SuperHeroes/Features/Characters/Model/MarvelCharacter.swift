//
//  MarvelCharacter.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import Foundation

// MARK: - Root Data Model

/// Represents the root response wrapper from the Marvel API.
public struct CharacterDataWrapper: Codable {
    let code: Int
    let status: String
    let data: CharacterDataContainer
}

// MARK: - Data Container

/// Contains a paginated list of Marvel characters.
public struct CharacterDataContainer: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [MarvelCharacter]
}

// MARK: - Marvel Character Model

/// Represents a Marvel character, including its ID, name, description, and thumbnail.
public struct MarvelCharacter: Codable, Hashable {
    let id: Int
    let name: String
    let description: String?
    let thumbnail: Thumbnail?
    
    /// Returns the full image URL of the character.
    var imageUrl: String? {
        return thumbnail?.fullUrl
    }
    
    /// Hash function to ensure unique identification of characters.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Equality check for `MarvelCharacter`, comparing only the ID.
    public static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Thumbnail Model

/// Represents the character's thumbnail image data.
public struct Thumbnail: Codable {
    let path: String
    let fileExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}

extension Thumbnail {
    
    /// Returns the complete image URL, ensuring it is secure (HTTPS).
    var fullUrl: String {
        let securePath = path.replacingOccurrences(of: "http:", with: "https:")
        return fileExtension.isEmpty ? securePath : "\(securePath).\(fileExtension)"
    }
}
