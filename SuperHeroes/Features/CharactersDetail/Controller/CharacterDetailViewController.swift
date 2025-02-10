//
//  CharacterDetailViewController.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// ViewController responsible for displaying character details.
class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The main view for character details.
    internal let characterDetailView = CharacterDetailView()
    
    /// ViewModel responsible for handling business logic.
    internal var viewModel: CharacterDetailViewModelProtocol
    
    /// Callback triggered when the favorite status changes.
    var onFavoriteStatusChanged: (() -> Void)?
    
    // MARK: - Initializers
    
    /**
     Initializes the view controller with a Marvel character.
     
     - Parameter character: The character to be displayed.
     */
    init(character: MarvelCharacter) {
        self.viewModel = CharacterDetailViewModel(character: character)
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Initializes the view controller with a specific ViewModel.
     This initializer is mainly used for dependency injection in tests.
     
     - Parameter viewModel: The ViewModel implementing `CharacterDetailViewModelProtocol`.
     */
    init(viewModel: CharacterDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        view = characterDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
        viewModel.loadCharacterData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setTabBarHidden(false)
    }
    
    // MARK: - UI Configuration
    
    /// Configures the UI based on the character's details.
    func setupUI() {
        characterDetailView.configure(
            with: viewModel.character,
            isFavorite: viewModel.isCharacterFavorite()
        )
    }
    
    /**
     Toggles the visibility of the tab bar.
     
     - Parameter isHidden: A Boolean indicating whether the tab bar should be hidden.
     */
    func setTabBarHidden(_ isHidden: Bool) {
        tabBarController?.setTabBarHidden(isHidden, animated: false)
    }
    
    // MARK: - ViewModel Bindings
    
    /// Sets up bindings between the ViewModel and the ViewController.
    func setupBindings() {
        viewModel.onImageLoaded = { [weak self] image in
            self?.characterDetailView.setImage(image)
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            self?.characterDetailView.toggleLoading(isLoading)
        }
        
        viewModel.onFavoriteStateChanged = { [weak self] isFavorite in
            self?.characterDetailView.updateFavoriteButton(isFavorite: isFavorite)
        }
        
        viewModel.onError = { [weak self] message in
            self?.characterDetailView.showError(message)
        }
    }

    // MARK: - User Actions
    
    /// Sets up UI interactions such as favorite and share actions.
    func setupActions() {
        characterDetailView.onFavoriteTapped = { [weak self] in
            self?.handleFavoriteAction()
        }
        
        characterDetailView.onShareTapped = { [weak self] in
            self?.shareCharacter()
        }
    }
    
    /// Toggles the character's favorite status and notifies any observers.
    func handleFavoriteAction() {
        viewModel.toggleFavorite()
        onFavoriteStatusChanged?()
    }
    
    /// Presents the system share sheet with the character image.
    func shareCharacter() {
        guard let image = characterDetailView.getCharacterImage() else {
            presentErrorAlert(message: "Imagem não disponível para compartilhamento.")
            return
        }

        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    /**
     Displays an error alert with a given message.
     
     - Parameter message: The error message to be displayed.
     */
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
