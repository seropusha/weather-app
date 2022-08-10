//
//  HomeAssembly.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core

final class HomeAssembly {
    
    static func assembly(with container: DIContainer) {
        let dataNetworkClient: NetworkClient = NetworkClientBuilder.build(
            serverBaseURL: URL(string: "http://api.openweathermap.org/")!,
            apiVersion: "data/2.5",
            authorizationCredentialsProvider: container.resolve(type: Session.self)
        )
        container.register(type: NetworkClient.self, name: "dataClient", component: dataNetworkClient)
        container.register(
            type: WeatherService.self,
            component: WeatherService(client: container.resolve(type: NetworkClient.self, name: "dataClient"))
        )
        container.register(type: HomeModel.self, component: HomeModel(container: container))
        container.register(type: HomeViewModel.self, component: HomeViewModel(model: container.resolve(type: HomeModel.self)))
    }
}
