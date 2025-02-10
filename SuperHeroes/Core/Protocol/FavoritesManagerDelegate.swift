//
//  FavoritesManagerDelegate.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 04/02/25.
//

protocol FavoritesManagerDelegate: AnyObject {
    func didUpdateFavorites()
    func didReceiveError(message: String)
}
