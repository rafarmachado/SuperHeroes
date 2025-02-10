//
//  SecureConstants.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import Foundation

/// Provides secure access to API credentials and configurations.
struct SecureConstants {

    // MARK: - API Base URL

    /// The base URL for the Marvel API, retrieved from `Info.plist`.
    static let baseURL: String = {
        return Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
    }()

    // MARK: - Public API Key

    /// The public API key, retrieved from `Info.plist`.
    static let publicKey: String = {
        return Bundle.main.object(forInfoDictionaryKey: "MARVEL_PUBLIC_KEY") as? String ?? ""
    }()

    // MARK: - Private API Key (Stored in Keychain)

    /// The key used to store the private API key in the Keychain.
    private static let privateKeyKeychainKey = "privateKey"

    /// Retrieves the private API key from the Keychain.
    /// If not found, a default development key is stored and returned.
    static var privateKey: String {
        if let key = KeychainHelper.shared.get(forKey: privateKeyKeychainKey) {
            return key
        } else {
            let initialKey = "SUA_PRIVATE_KEY_AQUI" // Default development key
            let success = KeychainHelper.shared.save(initialKey, forKey: privateKeyKeychainKey)
            if !success {
                print("Failed to save private key to Keychain")
            }
            return initialKey
        }
    }

    // MARK: - Keychain Management

    /// Saves a new private API key to the Keychain.
    ///
    /// - Parameter key: The private API key to store.
    static func savePrivateKey(_ key: String) {
        let success = KeychainHelper.shared.save(key, forKey: privateKeyKeychainKey)
        if !success {
            print("Failed to save private key in Keychain")
        }
    }

    /// Deletes the private API key from the Keychain.
    static func deletePrivateKey() {
        let success = KeychainHelper.shared.delete(forKey: privateKeyKeychainKey)
        if !success {
            print("Failed to delete private key from Keychain")
        }
    }
}
