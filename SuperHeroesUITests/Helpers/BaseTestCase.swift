//
//  BaseTestCase.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest

/// 🔥 Base para todos os testes de UI
class BaseTestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // 🚀 Inicializa o app antes de cada teste
        app = XCUIApplication()
        app.launchArguments = ["-UITests"] // 🔥 Permite comportamentos diferentes no app se necessário
        app.launch()
        
        // Continua o teste após falha
        continueAfterFailure = false
    }
    
    override func tearDown() {
        app.terminate()
        super.tearDown()
    }
    
    /// Espera até que um elemento esteja visível na tela
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) {
        let exists = element.waitForExistence(timeout: timeout)
        XCTAssertTrue(exists, "❌ O elemento esperado não apareceu na tela.")
    }
    
    /// Garante que a navegação volte para a tela inicial
    func returnToHomeScreen() {
        while app.navigationBars.buttons.element(boundBy: 0).exists {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }
}
