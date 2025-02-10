//
//  BaseListViewTests.swift
//  SuperHeroesTests
//
//  Created by Rafael Rezende Machado on 08/02/25.
//

//
//  BaseListViewTests.swift
//  SuperHeroesTests
//
//  Created by Test Developer on 08/02/25.
//

import XCTest
@testable import SuperHeroes

final class BaseListViewTests: XCTestCase {

    var baseListView: BaseListView!

    override func setUp() {
        super.setUp()
        baseListView = BaseListView(emptyMessage: "Nenhum personagem encontrado.")
    }

    override func tearDown() {
        baseListView = nil
        super.tearDown()
    }

    // MARK: - Testando a exibição de carregamento
    func testShowLoading_WhenTrue_ShouldShowOverlayAndSpinner() {
        baseListView.showLoading(true)
        
        XCTAssertFalse(baseListView.loadingOverlay.isHidden, "A overlay de loading deveria estar visível")
        XCTAssertTrue(baseListView.loadingIndicator.isAnimating, "O indicador de loading deveria estar animando")
        XCTAssertTrue(baseListView.emptyStateLabel.isHidden, "O rótulo de estado vazio deveria estar oculto")
        XCTAssertTrue(baseListView.errorLabel.isHidden, "O rótulo de erro deveria estar oculto")
    }

    func testShowLoading_WhenFalse_ShouldHideOverlayAndSpinner() {
        baseListView.showLoading(false)
        
        XCTAssertTrue(baseListView.loadingOverlay.isHidden, "A overlay de loading deveria estar oculta")
        XCTAssertFalse(baseListView.loadingIndicator.isAnimating, "O indicador de loading deveria estar parado")
    }

    // MARK: - Testando a exibição do estado vazio
    func testShowEmptyState_WhenTrue_ShouldHideTableAndShowEmptyLabel() {
        baseListView.showEmptyState(true)
        
        XCTAssertFalse(baseListView.emptyStateLabel.isHidden, "O rótulo de estado vazio deveria estar visível")
        XCTAssertTrue(baseListView.tableView.isHidden, "A tabela deveria estar oculta")
        XCTAssertTrue(baseListView.errorLabel.isHidden, "O rótulo de erro deveria estar oculto")
    }

    func testShowEmptyState_WhenFalse_ShouldShowTableAndHideEmptyLabel() {
        baseListView.showEmptyState(false)
        
        XCTAssertTrue(baseListView.emptyStateLabel.isHidden, "O rótulo de estado vazio deveria estar oculto")
        XCTAssertFalse(baseListView.tableView.isHidden, "A tabela deveria estar visível")
    }

    // MARK: - Testando a exibição de erros
    func testShowError_WhenMessageProvided_ShouldShowErrorLabelAndHideOthers() {
        let errorMessage = "Erro ao carregar os personagens"
        baseListView.showError(errorMessage)
        
        XCTAssertFalse(baseListView.errorLabel.isHidden, "O rótulo de erro deveria estar visível")
        XCTAssertEqual(baseListView.errorLabel.text, errorMessage, "O texto do erro deveria ser atualizado corretamente")
        XCTAssertTrue(baseListView.emptyStateLabel.isHidden, "O rótulo de estado vazio deveria estar oculto")
        XCTAssertTrue(baseListView.tableView.isHidden, "A tabela deveria estar oculta")
    }

    func testShowError_WhenNil_ShouldHideErrorLabel() {
        baseListView.showError(nil)
        
        XCTAssertTrue(baseListView.errorLabel.isHidden, "O rótulo de erro deveria estar oculto")
    }
}
