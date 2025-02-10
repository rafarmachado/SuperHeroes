//
//  AppearanceManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import UIKit

/// Manages the global appearance settings of the application.
final class AppearanceManager {
    
    /// Configures the global UI appearance settings.
    /// This method should be called once at the app startup.
    static func configureAppearance() {
        configureTabBar()
        configureNavigationBar()
    }

    // MARK: - Tab Bar Configuration
    
    /// Configures the global appearance of the `UITabBar`.
    static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Selected item styling
        appearance.stackedLayoutAppearance.selected.iconColor = .systemYellow
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        
        // Unselected item styling
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: - Navigation Bar Configuration
    
    /// Configures the global appearance of the `UINavigationBar`.
    private static func configureNavigationBar() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = .systemBackground
        navBarAppearance.tintColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.isTranslucent = false
    }
}
