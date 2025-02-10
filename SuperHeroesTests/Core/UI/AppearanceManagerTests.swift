//
//  Untitled.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class AppearanceManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        AppearanceManager.configureAppearance()
    }

    override func tearDown() {
        super.tearDown()
    }

    // 🔥 Testa se a tabBar foi configurada corretamente
    func testConfigureTabBar_ShouldApplyCorrectAppearance() {
           // Call the method to configure the tab bar
           AppearanceManager.configureTabBar()
           
           // Retrieve the UITabBar global appearance
           let tabBar = UITabBar.appearance()
           let appearance = tabBar.standardAppearance
           
           // Check if the background color is correctly applied
           XCTAssertEqual(appearance.backgroundColor, .white, "Tab Bar background color should be white")
           
           // Check if the selected item is yellow
           XCTAssertEqual(appearance.stackedLayoutAppearance.selected.iconColor, .systemYellow, "Selected icon should be yellow")
           XCTAssertEqual(appearance.stackedLayoutAppearance.selected.titleTextAttributes[.foregroundColor] as? UIColor, .systemYellow, "Selected text should be yellow")
           
           // Check if the unselected items are gray
           XCTAssertEqual(appearance.stackedLayoutAppearance.normal.iconColor, .gray, "Unselected icon should be gray")
           XCTAssertEqual(appearance.stackedLayoutAppearance.normal.titleTextAttributes[.foregroundColor] as? UIColor, .gray, "Unselected text should be gray")
       }

    // 🔥 Testa se a navigationBar foi configurada corretamente
    func testNavigationBarAppearance_ShouldHaveCorrectSettings() {
        let navBarAppearance = UINavigationBar.appearance()

        XCTAssertEqual(navBarAppearance.barTintColor, .systemBackground, "A navigationBar deveria ter fundo padrão do sistema.")
        XCTAssertEqual(navBarAppearance.tintColor, .black, "A cor da navigationBar deveria ser preta.")
        XCTAssertEqual(navBarAppearance.titleTextAttributes?[.foregroundColor] as? UIColor, UIColor.black, "O título da navigationBar deveria ser preto.")
        XCTAssertFalse(navBarAppearance.isTranslucent, "A navigationBar não deveria ser translúcida.")
    }
}
