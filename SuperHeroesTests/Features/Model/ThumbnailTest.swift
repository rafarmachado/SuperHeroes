//
//  ThumbnailTest.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 09/02/25.
//

import XCTest
@testable import SuperHeroes

final class ThumbnailTests: XCTestCase {

    // ✅ Teste de inicialização e conversão para URL segura
    func testThumbnail_ShouldReturnCorrectFullURL() {
        let thumbnail = Thumbnail(path: "http://example.com/image", fileExtension: "jpg")

        XCTAssertEqual(thumbnail.fullUrl, "https://example.com/image.jpg")
    }

    // ✅ Teste com caminho HTTPS já seguro
    func testThumbnail_ShouldKeepHTTPSIfAlreadySecure() {
        let thumbnail = Thumbnail(path: "https://secure.com/image", fileExtension: "png")

        XCTAssertEqual(thumbnail.fullUrl, "https://secure.com/image.png")
    }

    // ✅ Teste quando não há extensão de arquivo
    func testThumbnail_WhenNoExtension_ShouldReturnPathOnly() {
        let thumbnail = Thumbnail(path: "http://example.com/image", fileExtension: "")

        XCTAssertEqual(thumbnail.fullUrl, "https://example.com/image")
    }
}
