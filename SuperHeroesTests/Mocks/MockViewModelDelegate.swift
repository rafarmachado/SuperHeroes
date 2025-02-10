//
//  Untitled.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 08/02/25.
//
import Foundation
@testable import SuperHeroes

final class MockViewModelDelegate: ViewModelDelegate {
    var didUpdateDataCalled = false
    var didUpdateLoadingStateCalled = false
    var didReceiveErrorCalled = false
    var lastErrorMessage: String?

    func didUpdateData() {
        didUpdateDataCalled = true
    }
    
    func didUpdateLoadingState(isLoading: Bool) {
        didUpdateLoadingStateCalled = true
    }
    
    func didReceiveError(message: String) {
        didReceiveErrorCalled = true
        lastErrorMessage = message
    }
}
