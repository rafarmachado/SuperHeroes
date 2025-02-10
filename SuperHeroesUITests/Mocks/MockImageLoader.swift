//
//  MockImageLoader.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import UIKit
@testable import SuperHeroes

class MockImageLoader: ImageLoaderProtocol {
    var mockImage: UIImage?
    var shouldFail = false
    
    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        if shouldFail {
            completion(nil)
        } else {
            completion(mockImage ?? UIImage(named: "placeholder"))
        }
    }
    
    func cancelLoad(for url: URL) {
        // Simula o cancelamento da tarefa (não faz nada no mock)
    }
    
    func clearCache() {
        // Simula a limpeza do cache (não faz nada no mock)
    }
}
