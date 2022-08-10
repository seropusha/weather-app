//
//  SearchResultsAssembly.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core

final class SearchResultsAssembly {
    
    static func assembly(with container: DIContainer) {
        let geoNetworkClient: NetworkClient = NetworkClientBuilder.build(
            serverBaseURL: URL(string: "http://api.openweathermap.org/")!,
            apiVersion: "geo/1.0",
            authorizationCredentialsProvider: container.resolve(type: Session.self)
        )
        container.register(type: NetworkClient.self, name: "geoClient", component: geoNetworkClient)
        container.register(
            type: GeocodingService.self,
            component: GeocodingService(client: container.resolve(type: NetworkClient.self, name: "geoClient"))
        )
        container.register(type: SearchResultsModel.self, component: SearchResultsModel(container: container))
    }
}
