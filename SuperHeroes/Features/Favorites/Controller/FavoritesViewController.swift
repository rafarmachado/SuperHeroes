//
//  FavoritesViewController.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// ViewController responsible for displaying the list of favorite characters.
final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The main view displaying the favorites list.
    let favoritesView = FavoritesView()
    
    /// ViewModel responsible for managing favorite characters.
    var viewModel: FavoritesViewModelProtocol
    
    // MARK: - Initialization
    
    /**
     Initializes the FavoritesViewController with a given ViewModel.
     Defaults to `FavoritesViewModel` if no ViewModel is provided.
     
     - Parameter viewModel: The ViewModel implementing `FavoritesViewModelProtocol`.
     */
    init(viewModel: FavoritesViewModelProtocol = FavoritesViewModel(favoritesRepository: FavoritesManager.shared)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    // MARK: - UI Setup
    
    /// Configures the navigation bar and table view settings.
    func setupUI() {
        NavigationManager.setupNavigationBar(for: self, title: "Favoritos")
        favoritesView.tableView.dataSource = self
        favoritesView.tableView.delegate = self
        favoritesView.tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
    }
        
    // MARK: - Actions Setup
    
    /// Configures the pull-to-refresh action.
    func setupActions() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        favoritesView.tableView.refreshControl = refreshControl
    }
    
    /// Refreshes the list of favorite characters.
    @objc func refreshFavorites() {
        viewModel.fetchFavorites()
        favoritesView.tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
     Returns the number of favorite characters.
     
     - Parameter tableView: The table view requesting this information.
     - Parameter section: The section index.
     - Returns: The number of favorite characters.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteCharacters.count
    }
    
    /**
     Configures and returns a cell for a given index path.
     
     - Parameter tableView: The table view requesting the cell.
     - Parameter indexPath: The index path of the cell.
     - Returns: A configured table view cell.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        
        let character = viewModel.favoriteCharacters[indexPath.row]
        let isFavorite = viewModel.isFavorite(characterId: character.id)
        
        cell.configure(with: character, isFavorite: isFavorite)
        
        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.toggleFavorite(for: character)
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        return cell
    }
    
    /**
     Handles character selection and navigates to the character detail screen.
     
     - Parameter tableView: The table view reporting the selection.
     - Parameter indexPath: The index path of the selected character.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = viewModel.favoriteCharacters[indexPath.row]
        
        let detailVC = CharacterDetailViewController(character: selectedCharacter)
        
        detailVC.onFavoriteStatusChanged = { [weak self] in
            self?.viewModel.fetchFavorites()
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - ViewModelDelegate

extension FavoritesViewController: ViewModelDelegate {
    
    /**
     Handles updates to the pagination state.
     
     - Parameter isLoadingMore: Indicates if more data is being loaded.
     */
    func didUpdatePaginationState(isLoadingMore: Bool) {
        // Not necessary in this implementation.
    }
    
    /**
     Handles updates to the loading state.
     
     - Parameter isLoading: Indicates if the data is currently loading.
     */
    func didUpdateLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            self.favoritesView.showLoading(isLoading)
        }
    }
    
    /**
     Updates the UI when new data is available.
     */
    func didUpdateData() {
        DispatchQueue.main.async {
            self.favoritesView.showEmptyState(self.viewModel.favoriteCharacters.isEmpty)
            self.favoritesView.tableView.reloadData()
        }
    }
    
    /**
     Displays an error message in case of a failure.
     
     - Parameter message: The error message to be displayed.
     */
    func didReceiveError(message: String) {
        DispatchQueue.main.async {
            self.favoritesView.showError(message)
        }
    }
}
