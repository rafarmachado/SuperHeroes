//
//  NavigationManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import UIKit

/// Manages the centralized configuration of the NavigationBar and SearchController.
final class NavigationManager {
    
    /// Configures the `NavigationBar` with a large title and an optional `SearchController`.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` where the navigation bar should be configured.
    ///   - title: The title to display in the navigation bar.
    ///   - searchController: An optional `UISearchController` to be added to the navigation bar.
    static func setupNavigationBar(
        for viewController: UIViewController,
        title: String,
        searchController: UISearchController? = nil
    ) {
        viewController.title = title
        let navigationBar = viewController.navigationController?.navigationBar
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = nil
        appearance.shadowImage = UIImage()
        
        navigationBar?.standardAppearance = appearance
        navigationBar?.scrollEdgeAppearance = appearance
        navigationBar?.compactAppearance = appearance
        navigationBar?.prefersLargeTitles = true
        navigationBar?.isTranslucent = false
        
        viewController.navigationItem.backButtonDisplayMode = .minimal
        
        if let searchController = searchController {
            configureSearchController(searchController, for: viewController)
        }
    }
    
    // MARK: - Search Controller Configuration
    
    /// Configures the `UISearchController` and attaches it to the given `UIViewController`.
    ///
    /// - Parameters:
    ///   - searchController: The search controller instance to be configured.
    ///   - viewController: The view controller where the search controller should be applied.
    private static func configureSearchController(
        _ searchController: UISearchController,
        for viewController: UIViewController
    ) {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar personagens..."
        
        viewController.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = viewController as? UISearchResultsUpdating
        searchController.searchBar.delegate = viewController as? UISearchBarDelegate
        
        viewController.definesPresentationContext = true
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        
        DispatchQueue.main.async {
            viewController.navigationItem.searchController?.isActive = false
        }
    }
}
