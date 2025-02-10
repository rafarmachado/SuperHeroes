//
//  NetworkMonitor.swift
//  SuperHeroes
//
//  Created by Rafael Rezende Machado on 06/02/25.
//

import Network
protocol NetworkMonitorProtocol {
    func isInternetAvailable() -> Bool
}

final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private var isConnected: Bool = true

    private init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }

    func isInternetAvailable() -> Bool {
        return isConnected
    }
}
