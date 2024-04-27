//
//  Container.swift
//  bivi
//
//  Created by d.tatarinova on 24.03.2024.
//

import Factory

extension Container {
    var networkManager: Factory<NetworkManager> {
        self { NetworkManagerImpl() }.scope(.shared)
    }

    var logger: Factory<Logger> {
        self { LoggerImpl() }.scope(.singleton)
    }
}
