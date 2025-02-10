//
//  FavoritesView.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// View responsible for displaying the list of favorite characters.
final class FavoritesView: BaseListView {

    // MARK: - Initialization
    
    /**
     Initializes the view with a default empty message.
     The message is displayed when there are no favorite characters.
     */
    init() {
        super.init(emptyMessage: "Nenhum personagem favoritado.") // ✅ Calls the correct initializer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
