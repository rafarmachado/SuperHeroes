//
//  MockTabBarController.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//
import UIKit

final class MockTabBarController: UITabBarController {
    
    private(set) var lastTabBarHiddenState: Bool = false
    
    override func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        super.setTabBarHidden(hidden, animated: animated)
        lastTabBarHiddenState = hidden
    }
}
