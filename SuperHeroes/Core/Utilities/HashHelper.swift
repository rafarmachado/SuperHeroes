//
//  HashHelper.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import Foundation
import CryptoKit

class HashHelper {
    
    /// Generate a MD5 hash from string
    /// - Parameter input: String to convert
    /// - Returns: String contains md5
    static func generateMD5(from input: String) -> String {
        let digest = Insecure.MD5.hash(data: input.data(using: .utf8)!)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
