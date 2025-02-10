//
//  BaseTestCase.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

/// 🔥 Classe base para testes unitários, garantindo reset do estado do app.
class BaseTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        resetAppState()
    }

    override func tearDown() {
        resetAppState()
        super.tearDown()
    }

    /// 🔥 Reseta o estado do app antes e depois de cada teste para evitar estado persistente
    private func resetAppState() {
        FavoritesManager.shared.clearFavorites()
        CacheManager.shared.clearCache()
        ImageLoader.shared.clearCache()
    }
}
