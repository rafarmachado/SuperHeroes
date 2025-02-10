//
//  ImageCacheManagerTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//

import XCTest
@testable import SuperHeroes

final class ImageCacheManagerTests: XCTestCase {
    
    var imageCacheManager: ImageCacheManager!
    let testURL = URL(string: "https://example.com/testImage.jpg")!
    
    override func setUp() {
        super.setUp()
        imageCacheManager = ImageCacheManager.shared
        imageCacheManager.clearCache()
    }
    
    override func tearDown() {
        imageCacheManager.clearCache()
        imageCacheManager = nil
        super.tearDown()
    }
    
    func testSaveAndLoadImage() {
        let testImage = UIImage(systemName: "star.fill")!
        
        imageCacheManager.saveImage(testImage, for: testURL)
        let loadedImage = imageCacheManager.loadImage(for: testURL)
        
        XCTAssertNotNil(loadedImage, "A imagem salva deve ser carregada corretamente.")
    }
    
    func testCachePersistsAfterMemoryFlush() {
        let testImage = UIImage(systemName: "star.fill")!
        
        imageCacheManager.saveImage(testImage, for: testURL)
        imageCacheManager.clearCache()
        
        let loadedImage = imageCacheManager.loadImage(for: testURL)
        XCTAssertNil(loadedImage, "A imagem não deve ser encontrada após limpar o cache.")
    }
    
    func testClearCache() {
        let testImage = UIImage(systemName: "star.fill")!
        
        imageCacheManager.saveImage(testImage, for: testURL)
        imageCacheManager.clearCache()
        
        let loadedImage = imageCacheManager.loadImage(for: testURL)
        XCTAssertNil(loadedImage, "O cache deve ser completamente limpo.")
    }
}
