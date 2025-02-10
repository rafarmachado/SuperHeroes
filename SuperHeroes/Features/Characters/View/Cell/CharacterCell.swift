//
//  CharacterCell.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import UIKit

/// Custom `UITableViewCell` used to display Marvel characters in a list.
final class CharacterCell: UITableViewCell {
    
    /// Cell identifier used for dequeuing.
    static let identifier = "CharacterCell"
    
    /// Displays the character's image.
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Displays the character's name.
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Button to toggle favorite status.
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Indicates if the character is marked as favorite.
    var isFavorite: Bool = false
    
    /// Stores the character associated with this cell.
    var character: MarvelCharacter?
    
    /// Callback triggered when the favorite button is tapped.
    var onFavoriteTapped: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Prepares the cell for reuse by resetting the image and canceling image loading.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImageView.image = UIImage(named: "placeholder")
        
        if let imageUrl = character?.imageUrl, let url = URL(string: imageUrl) {
            ImageLoader.shared.cancelLoad(for: url)
        }
        
        character = nil
        isFavorite = false
        updateFavoriteButton()
    }
    
    // MARK: - Cell Configuration
    
    /// Configures the cell with character data.
    ///
    /// - Parameters:
    ///   - character: The `MarvelCharacter` to display.
    ///   - isFavorite: Boolean indicating if the character is favorited.
    func configure(with character: MarvelCharacter, isFavorite: Bool) {
        self.character = character
        self.isFavorite = isFavorite
        
        nameLabel.text = character.name
        updateFavoriteButton()
        
        // Sets a placeholder image before loading
        characterImageView.image = UIImage(named: "placeholder")
        
        guard let imageUrl = character.thumbnail?.fullUrl else { return }
        
        // Tries to load image from cache first
        if let cachedImage = CacheManager.shared.loadImage(for: imageUrl) {
            characterImageView.image = cachedImage
        } else {
            // Downloads image if not cached and saves it
            ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    guard let self = self, self.character?.id == character.id else { return }
                    self.characterImageView.image = image
                    if let image = image, self.isFavorite {
                        CacheManager.shared.saveImage(image, for: imageUrl)
                    }
                }
            }
        }
    }
    
    // MARK: - UI Setup
    
    /// Configures the layout and constraints of the cell.
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [characterImageView, nameLabel, favoriteButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            characterImageView.widthAnchor.constraint(equalToConstant: 48),
            characterImageView.heightAnchor.constraint(equalToConstant: 48),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    /// Updates the favorite button's appearance based on `isFavorite` state.
    func updateFavoriteButton() {
        let iconName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    /// Handles the favorite button tap action.
    @objc func didTapFavorite() {
        isFavorite.toggle()
        updateFavoriteButton()
        onFavoriteTapped?()
    }
}
