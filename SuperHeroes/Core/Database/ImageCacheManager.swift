//
//  ImageCacheManager.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import UIKit

/// Manages image caching, storing images in memory and disk for better performance.
final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    var cache = NSCache<NSURL, UIImage>()
    var fileManager = FileManager.default
    var cacheDirectory: URL

    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache", isDirectory: true)

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    // MARK: - Save Image

    /// Saves an image to memory cache and disk storage.
    /// - Parameters:
    ///   - image: The `UIImage` to be saved.
    ///   - url: The `URL` associated with the image.
    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
        let imagePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: imagePath)
        }
    }

    // MARK: - Load Image

    /// Retrieves an image from memory cache or disk storage.
    /// - Parameter url: The `URL` of the image.
    /// - Returns: The `UIImage` if found, otherwise `nil`.
    func loadImage(for url: URL) -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }

        let imagePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = try? Data(contentsOf: imagePath), let image = UIImage(data: data) {
            cache.setObject(image, forKey: url as NSURL)
            return image
        }

        return nil
    }

    // MARK: - Clear Cache

    /// Clears all stored images from memory and disk.
    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
    }
}
