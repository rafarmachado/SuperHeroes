//
//  UITestHelper.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest

/// 🔥 Métodos auxiliares para os testes de UI
final class UITestHelper {

    static func tap(_ element: XCUIElement) {
        XCTAssertTrue(element.exists, "❌ Elemento não encontrado: \(element)")
        element.tap()
    }
    
    static func typeText(_ element: XCUIElement, text: String, clearText: Bool = true) {
        XCTAssertTrue(element.exists, "❌ Elemento não encontrado: \(element)")
        
        element.tap()
        if clearText, let stringValue = element.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            element.typeText(deleteString)
        }
        element.typeText(text)
    }
    
    static func scrollTo(_ element: XCUIElement, app: XCUIApplication, maxScrolls: Int = 5) {
        var scrolls = 0
        while !element.exists && scrolls < maxScrolls {
            app.swipeUp()
            scrolls += 1
        }
        XCTAssertTrue(element.exists, "❌ O elemento não foi encontrado após \(maxScrolls) tentativas de rolagem.")
    }
    
    static func assertExists(_ element: XCUIElement) {
        XCTAssertTrue(element.exists, "❌ O elemento esperado não foi encontrado na tela.")
    }
    
    static func assertNotExists(_ element: XCUIElement) {
        XCTAssertFalse(element.exists, "❌ O elemento deveria estar oculto, mas está visível.")
    }
}
