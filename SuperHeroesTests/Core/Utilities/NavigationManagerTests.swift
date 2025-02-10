//
//  NavigationManagerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class NavigationManagerTests: XCTestCase {
    
    var viewController: UIViewController!
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        navigationController = UINavigationController(rootViewController: viewController)
    }
    
    override func tearDown() {
        viewController = nil
        navigationController = nil
        super.tearDown()
    }
    
    func testSetupNavigationBar_WithoutSearchController() {
        NavigationManager.setupNavigationBar(for: viewController, title: "SuperHeroes")
        
        XCTAssertEqual(viewController.title, "SuperHeroes", "O título da NavigationBar deve ser configurado corretamente.")
        XCTAssertTrue(viewController.navigationController?.navigationBar.prefersLargeTitles ?? false, "A NavigationBar deve preferir títulos grandes.")
        XCTAssertEqual(viewController.navigationItem.backButtonDisplayMode, .minimal, "O botão de voltar deve estar no modo minimalista.")
    }
    
    func testSetupNavigationBar_WithSearchController() {
        let searchController = UISearchController()
        NavigationManager.setupNavigationBar(for: viewController, title: "SuperHeroes", searchController: searchController)
        
        XCTAssertNotNil(viewController.navigationItem.searchController, "O SearchController deve ser atribuído à NavigationBar.")
        XCTAssertFalse(searchController.obscuresBackgroundDuringPresentation, "O SearchController não deve obscurecer o fundo durante a apresentação.")
        XCTAssertFalse(searchController.hidesNavigationBarDuringPresentation, "O SearchController não deve esconder a NavigationBar durante a apresentação.")
        XCTAssertEqual(searchController.searchBar.placeholder, "Buscar personagens...", "O placeholder do SearchBar deve ser configurado corretamente.")
    }
}
