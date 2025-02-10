//
//  ImageLoader.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

//
//  ImageLoader.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 03/02/25.
//

import UIKit

/// Protocol defining image loading capabilities.
public protocol ImageLoaderProtocol {
    /// Loads an image from a given URL string.
    /// - Parameters:
    ///   - urlString: The string representing the image URL.
    ///   - completion: A closure returning the loaded `UIImage?`.
    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void)

    /// Cancels an active image download request.
    /// - Parameter url: The URL of the image being downloaded.
    func cancelLoad(for url: URL)

    /// Clears both memory and disk cache for images.
    func clearCache()
}

// MARK: - ImageLoader Implementation
final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    
    var memoryCache = NSCache<NSURL, UIImage>()
    var session: URLSessionProtocol
    var activeTasks: [URL: URLSessionDataTask] = [:]
    
    /// Initializes the `ImageLoader` with a customizable session (for testing).
    /// - Parameter session: The session used for network requests. Defaults to `URLSession.shared`.
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Load Image
    
    /// Fetches an image from the given URL string, utilizing memory and disk cache.
    /// - Parameters:
    ///   - urlString: The image URL in string format.
    ///   - completion: A closure returning the loaded `UIImage?`.
    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(UIImage(named: "placeholder"))
            return
        }
        
        // Check memory cache first
        if let cachedImage = CacheManager.shared.loadImage(for: urlString) {
            completion(cachedImage)
            return
        }
        
        if let memoryCachedImage = memoryCache.object(forKey: url as NSURL) {
            completion(memoryCachedImage)
            return
        }
        
        // Prevent duplicate downloads
        if activeTasks[url] != nil {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // Cache image in memory
            self.memoryCache.setObject(image, forKey: url as NSURL)
            
            // Save image to disk cache
            CacheManager.shared.saveImage(image, for: urlString)
            
            DispatchQueue.main.async { completion(image) }
            
            self.activeTasks[url] = nil
        }
        
        activeTasks[url] = task
        task.resume()
    }
    
    // MARK: - Cancel Image Load
    
    /// Cancels an ongoing image download request.
    /// - Parameter url: The URL of the image being downloaded.
    func cancelLoad(for url: URL) {
        activeTasks[url]?.cancel()
        activeTasks[url] = nil
    }
    
    // MARK: - Cache Management
    
    /// Clears all cached images from memory and disk.
    func clearCache() {
        memoryCache.removeAllObjects()
        CacheManager.shared.clearCacheImage()
    }
}
