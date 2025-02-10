//
//  AppCoordinatorTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class AppCoordinatorTests: XCTestCase {
    
    var window: UIWindow!
    var appCoordinator: AppCoordinator!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window)
    }
    
    override func tearDown() {
        appCoordinator = nil
        window = nil
        super.tearDown()
    }
    
    func testStart_SetsRootViewController() {
        appCoordinator.start()
        
        guard let rootVC = window.rootViewController as? UITabBarController else {
            XCTFail("RootViewController is not UITabBarController")
            return
        }
        
        XCTAssertEqual(rootVC.viewControllers?.count, 2, "Expected 2 view controllers in the tab bar")
        
        let charactersNavVC = rootVC.viewControllers?[0] as? UINavigationController
        let favoritesNavVC = rootVC.viewControllers?[1] as? UINavigationController
        
        XCTAssertNotNil(charactersNavVC, "Characters navigation controller should not be nil")
        XCTAssertNotNil(favoritesNavVC, "Favorites navigation controller should not be nil")
        
        XCTAssertTrue(charactersNavVC?.topViewController is CharactersViewController, "First tab should be CharactersViewController")
        XCTAssertTrue(favoritesNavVC?.topViewController is FavoritesViewController, "Second tab should be FavoritesViewController")
    }
}
