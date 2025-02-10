//
//  CharactersScreen.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest

final class CharactersScreen {
    
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    var tableView: XCUIElement {
        return app.tables["CharacterTableView"]
    }
    
    var searchBar: XCUIElement {
        return app.searchFields["Buscar personagens..."]
    }
    
    var retryButton: XCUIElement {
        return app.buttons["Tentar novamente"]
    }
    
    func tapCharacter(at index: Int) {
        let cell = tableView.cells.element(boundBy: index)
        cell.tap()
    }
    
    func searchCharacter(name: String) {
        searchBar.tap()
        searchBar.typeText(name)
    }
    
    func tapRetryButton() {
        retryButton.tap()
    }
}
