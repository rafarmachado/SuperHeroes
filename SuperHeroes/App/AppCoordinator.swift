//
//  AppCoordinator.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

class AppCoordinator {
    
    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }
    
    /// Starts the application by setting up the tab bar controller with its view controllers.
    ///
    /// This method:
    /// - Creates a `UITabBarController` as the root view controller.
    /// - Configures two navigation controllers:
    ///   - `CharactersViewController` for listing characters.
    ///   - `FavoritesViewController` for managing favorite characters.
    /// - Assigns appropriate tab bar items with icons and titles.
    /// - Sets the tab bar controller as the root of the app's window.
    func start() {
        let tabBarController = UITabBarController()
        
        // Configure the tab bar appearance
        tabBarController.tabBar.tintColor = .darkGray
        
        // Characters List Tab
        let charactersVC = UINavigationController(rootViewController: CharactersViewController())
        charactersVC.tabBarItem = UITabBarItem(title: "Personagens", image: UIImage(systemName: "person.3.fill"), tag: 0)

        // Favorites Tab
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "star.fill"), tag: 1)

        // Assign the view controllers to the tab bar
        tabBarController.viewControllers = [charactersVC, favoritesVC]

        // Set the root view controller and make the window key and visible
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
