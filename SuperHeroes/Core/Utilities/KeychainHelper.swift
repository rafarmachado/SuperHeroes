//
//  KeychainHelper.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//
import Foundation
import Security

/// A helper class for securely storing and retrieving data using Keychain Services.
final class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}

    // MARK: - Save Data
    /// Saves a value in the Keychain.
    /// - Parameters:
    ///   - value: The string value to be stored.
    ///   - key: The key under which the value will be stored.
    /// - Returns: `true` if the operation was successful, `false` otherwise.
    func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        // Delete existing entry if needed
        _ = delete(forKey: key)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Retrieve Data
    /// Retrieves a value from the Keychain.
    /// - Parameter key: The key associated with the stored value.
    /// - Returns: The stored string if found, otherwise `nil`.
    func get(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Delete Data
    /// Deletes a value from the Keychain.
    /// - Parameter key: The key associated with the stored value.
    /// - Returns: `true` if the operation was successful, `false` otherwise.
    func delete(forKey key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
