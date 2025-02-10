//
//  CharacterDetailView.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// View responsible for displaying character details.
final class CharacterDetailView: UIView {
    
    // MARK: - UI Components
    
    /// Displays the character's image.
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// Displays the character's name.
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Displays the character's description.
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Button to mark the character as favorite or remove from favorites.
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⭐ Favoritar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .systemYellow
        button.backgroundColor = .tertiarySystemBackground
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()
    
    /// Button to share the character details.
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📤 Compartilhar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .systemBlue
        button.backgroundColor = .tertiarySystemBackground
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return button
    }()

    /// Displays a loading indicator when fetching data.
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Callbacks
    
    /// Closure triggered when the favorite button is tapped.
    var onFavoriteTapped: (() -> Void)?
    
    /// Closure triggered when the share button is tapped.
    var onShareTapped: (() -> Void)?

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    
    /// Sets up the layout and constraints for UI components.
    private func setupUI() {
        backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [favoriteButton, shareButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(characterImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(stackView)
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            characterImageView.widthAnchor.constraint(equalToConstant: 180),
            characterImageView.heightAnchor.constraint(equalToConstant: 180),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),

            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor)
        ])
    }

    // MARK: - Configure View
    
    /**
     Configures the view with character details.
     
     - Parameters:
        - character: The character to display.
        - isFavorite: Boolean indicating if the character is marked as favorite.
     */
    func configure(with character: MarvelCharacter, isFavorite: Bool) {
        nameLabel.text = character.name
        descriptionLabel.text = (character.description?.isEmpty == false) ? character.description : "Detalhes não disponíveis"
        updateFavoriteButton(isFavorite: isFavorite)
    }

    // MARK: - User Actions
    
    /// Handles the favorite button tap action.
    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }

    /// Handles the share button tap action.
    @objc private func shareTapped() {
        onShareTapped?()
    }

    // MARK: - UI Updates
    
    /**
     Sets the image for the character.
     
     - Parameter image: The image to display.
     */
    func setImage(_ image: UIImage?) {
        characterImageView.image = image
    }

    /**
     Updates the favorite button title based on the character's favorite status.
     
     - Parameter isFavorite: Boolean indicating if the character is marked as favorite.
     */
    func updateFavoriteButton(isFavorite: Bool) {
        let title = isFavorite ? "⭐ Remover Favorito" : "⭐ Favoritar"
        favoriteButton.setTitle(title, for: .normal)
    }

    /**
     Toggles the loading indicator visibility.
     
     - Parameter isLoading: Boolean indicating if the loading state is active.
     */
    func toggleLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    /**
     Displays an error message in the description label.
     
     - Parameter message: The error message to be displayed.
     */
    func showError(_ message: String) {
        descriptionLabel.text = message
        descriptionLabel.textColor = .systemRed
    }
    
    // MARK: - Share Image
    
    /// Returns the character's image, if available.
    func getCharacterImage() -> UIImage? {
        return characterImageView.image
    }
}
