//
//  ViewModelDelegate.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

public protocol ViewModelDelegate: AnyObject {
    func didUpdateData()
    func didUpdateLoadingState(isLoading: Bool)
    func didReceiveError(message: String)
}
