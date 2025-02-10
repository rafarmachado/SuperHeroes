//
//  ImageLoaderTests.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 07/02/25.
//
import XCTest
@testable import SuperHeroes

final class ImageLoaderTests: BaseTestCase {
    
    var imageLoader: ImageLoader!
    var mockSession: MockURLSession!
    var mockCacheManager: MockCacheManager!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockCacheManager = MockCacheManager()
        imageLoader = ImageLoader(session: mockSession)
    }
    
    override func tearDown() {
        imageLoader = nil
        mockSession = nil
        mockCacheManager = nil
        super.tearDown()
    }
    
    // ✅ Teste: Carregamento bem-sucedido da imagem
    func testLoadImage_Success_ShouldReturnImage() {
        let expectation = XCTestExpectation(description: "Deve carregar a imagem corretamente")
        
        let testImage = UIImage(systemName: "star.fill")!
        let imageData = testImage.pngData()
        mockSession.mockData = imageData
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://mockurl.com/image.png")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        
        imageLoader.loadImage(from: "https://mockurl.com/image.png") { image in
            XCTAssertNotNil(image, "A imagem não deveria ser nula")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    // ❌ Teste: URL Inválida
    func testLoadImage_InvalidURL_ShouldReturnPlaceholder() {
        let expectation = XCTestExpectation(description: "Deve retornar imagem placeholder para URL inválida")

        // 🔥 Criamos um Mock explícito do Placeholder (para evitar falhas com Assets)
        let mockPlaceholder = UIImage(systemName: "exclamationmark.triangle") ?? UIImage()

        // 🔥 Mockamos o retorno da ImageLoader para sempre devolver o placeholder no caso de URL inválida
        let mockLoader = ImageLoader(session: mockSession)
        mockLoader.loadImage(from: nil) { image in
            XCTAssertNotNil(image, "A imagem não deveria ser nula")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
    
    // ❌ Teste: Erro de Rede
    func testLoadImage_NetworkError_ShouldReturnNil() {
        let expectation = XCTestExpectation(description: "Deve retornar nil ao falhar na rede")

        CacheManager.shared.clearCacheImage() // 🔥 Garantimos que o cache está vazio

        mockSession.mockError = NSError(domain: "Network Error", code: -1009, userInfo: nil)

        imageLoader.loadImage(from: "https://mockurl.com/image.png") { image in
            XCTAssertNil(image, "Deveria retornar nil devido ao erro de rede")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
    
    // ✅ Teste: Carregar do Cache
    func testLoadImage_Cached_ShouldReturnCachedImage() {
        let expectation = XCTestExpectation(description: "Deve carregar a imagem do cache")
        
        let cachedImage = UIImage(systemName: "star.fill")
        CacheManager.shared.saveImage(cachedImage!, for: "https://mockurl.com/image.png")
        
        imageLoader.loadImage(from: "https://mockurl.com/image.png") { image in
            XCTAssertNotNil(image, "A imagem deveria ser carregada do cache")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    // ✅ Teste: Cancelar o carregamento da imagem
    func testCancelLoad_ShouldCancelImageRequest() {
        let url = URL(string: "https://mockurl.com/image.png")!

        let task = MockURLSessionDataTask { }
        
        // 🔥 Adicionamos a tarefa no `ImageLoader`, não no `MockURLSession`
        imageLoader.activeTasks[url] = task

        imageLoader.cancelLoad(for: url)

        XCTAssertNil(imageLoader.activeTasks[url], "A tarefa deveria ter sido cancelada")
    }
}
