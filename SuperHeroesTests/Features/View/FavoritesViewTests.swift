//
//  FavoritesViewTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

final class FavoritesViewTests: XCTestCase {

    var favoritesView: FavoritesView!

    override func setUp() {
        super.setUp()
        favoritesView = FavoritesView()
    }

    override func tearDown() {
        favoritesView = nil
        super.tearDown()
    }

    // ✅ Testa se a View inicializa corretamente (Apenas garantindo que a instância existe)
    func testFavoritesView_Initialization_ShouldCreateInstance() {
        XCTAssertNotNil(favoritesView, "A instância de FavoritesView deveria ser criada corretamente.")
    }

    // ✅ Testa se FavoritesView herda de BaseListView
    func testFavoritesView_ShouldInheritFromBaseListView() {
        XCTAssertTrue(favoritesView.isKind(of: BaseListView.self), "FavoritesView deveria herdar de BaseListView")
    }

    // ✅ Testa se a mensagem de estado vazio é mostrada corretamente
    func testFavoritesView_ShouldShowEmptyState() {
        favoritesView.showEmptyState(true)
        
        XCTAssertTrue(favoritesView.tableView.isHidden, "A tabela deveria ser escondida ao exibir estado vazio")
        XCTAssertFalse(favoritesView.emptyStateLabel.isHidden, "O label de estado vazio deveria estar visível")
    }
}
