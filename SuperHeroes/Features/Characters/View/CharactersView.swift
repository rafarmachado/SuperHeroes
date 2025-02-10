//
//  CharactersView.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import UIKit

/// `CharactersView` represents the UI for displaying a list of Marvel characters.
/// It extends `BaseListView` to inherit common UI elements like a table view and error handling.
final class CharactersView: BaseListView {
    
    /// Search controller to enable character search within the list.
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar personagens..."
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    /// Button to retry fetching data in case of an error.
    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tentar novamente", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    /// Initializes the `CharactersView` and sets up the UI components.
    init() {
        super.init(emptyMessage: "Nenhum personagem encontrado.")
        addSubview(retryButton)
        setupRetryConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    /// Configures the constraints for the retry button.
    private func setupRetryConstraints() {
        NSLayoutConstraint.activate([
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12),
            retryButton.widthAnchor.constraint(equalToConstant: 180),
            retryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - UI Updates
    
    /// Toggles the visibility of the retry button.
    ///
    /// - Parameter show: Boolean indicating whether to show the button.
    func showRetryButton(_ show: Bool) {
        retryButton.isHidden = !show
    }
}
