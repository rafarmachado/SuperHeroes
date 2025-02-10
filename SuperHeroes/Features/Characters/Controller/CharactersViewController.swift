//
//  CharactersViewController.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// ViewController responsible for displaying a list of Marvel characters.
class CharactersViewController: UIViewController {
    
    let characterView = CharactersView()
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel: CharactersViewModelProtocol

    var isLoadingMore = false

    /// Initializes the controller with a ViewModel.
    /// - Parameter viewModel: The ViewModel handling data operations.
    init(viewModel: CharactersViewModelProtocol = CharactersViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchCharacters(forceUpdate: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        characterView.tableView.reloadData()
    }
    
    // MARK: - UI Setup

    /// Configures the navigation bar and table view properties.
    private func setupUI() {
        NavigationManager.setupNavigationBar(for: self, title: "Personagens", searchController: searchController)
        
        characterView.tableView.dataSource = self
        characterView.tableView.delegate = self
        characterView.tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        characterView.retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }
    
    /// Handles retry button tap, triggering a new API request.
    @objc func didTapRetry() {
        characterView.showRetryButton(false)
        viewModel.fetchCharacters(forceUpdate: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Returns the number of characters in the filtered list.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCharacters.count
    }
    
    /// Configures the character cell with data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        
        let character = viewModel.filteredCharacters[indexPath.row]
        let isFavorite = viewModel.isFavorite(characterId: character.id)
        
        cell.configure(with: character, isFavorite: isFavorite)
        
        cell.onFavoriteTapped = { [weak self] in
            self?.handleFavoriteTap(for: character, at: indexPath)
        }
        
        return cell
    }
    
    /// Navigates to the character details screen when a row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = viewModel.filteredCharacters[indexPath.row]
        let detailVC = CharacterDetailViewController(character: selectedCharacter)
        
        detailVC.onFavoriteStatusChanged = { [weak self] in
            guard let self = self else { return }
            self.viewModel.updateFavoriteStatus(for: selectedCharacter)
            
            DispatchQueue.main.async {
                self.characterView.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

    /// Loads more characters when scrolling reaches the bottom.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchController.isActive {
            searchController.searchBar.resignFirstResponder()
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100, !isLoadingMore {
            isLoadingMore = true
            viewModel.loadMoreCharacters()
        }
    }
    
    /// Updates the favorite status of a character and refreshes its cell.
    func handleFavoriteTap(for character: MarvelCharacter, at indexPath: IndexPath) {
        viewModel.toggleFavorite(for: character)
        characterView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UISearchResultsUpdating & UISearchBarDelegate

extension CharactersViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    /// Updates the list when the user types in the search bar.
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchCharacter(with: searchText)
    }
    
    /// Clears the search results when the cancel button is tapped.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchCharacter(with: "")
    }
}

// MARK: - CharactersViewModelDelegate

extension CharactersViewController: ViewModelDelegate {
    
    /// Updates the UI when the loading state changes.
    func didUpdateLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            self.characterView.showLoading(isLoading)
        }
    }
    
    /// Updates the UI when new data is available.
    func didUpdateData() {
        DispatchQueue.main.async {
            self.characterView.showLoading(false)
            self.characterView.showEmptyState(self.viewModel.filteredCharacters.isEmpty)
            self.characterView.tableView.reloadData()
            self.characterView.showRetryButton(false)
            self.isLoadingMore = false
        }
    }
    
    /// Displays an error message when a failure occurs.
    func didReceiveError(message: String) {
        DispatchQueue.main.async {
            self.characterView.showError(message)
            self.characterView.showRetryButton(true)
            self.isLoadingMore = false
        }
    }
}
