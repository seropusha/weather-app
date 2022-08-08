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
        container.register(type: Settings.self, component: Settings(storage: UserDefaults.standard))
        container.register(type: Session.self, component: Session())
        let geoNetworkClient: NetworkClient = NetworkClientBuilder.build(
            serverBaseURL: URL(string: "http://api.openweathermap.org/")!,
            apiVersion: "geo/1.0",
            authorizationCredentialsProvider: container.resolve(type: Session.self)
        )
        let dataNetworkClient: NetworkClient = NetworkClientBuilder.build(
            serverBaseURL: URL(string: "http://api.openweathermap.org/")!,
            apiVersion: "data/2.5",
            authorizationCredentialsProvider: container.resolve(type: Session.self)
        )
        container.register(type: NetworkClient.self, name: "geoClient", component: geoNetworkClient)
        container.register(type: NetworkClient.self, name: "dataClient", component: dataNetworkClient)
        container.register(
            type: GeocidingService.self,
            component: GeocidingService(client: container.resolve(type: NetworkClient.self, name: "geoClient"))
        )
        container.register(
            type: WeatherService.self,
            component: WeatherService(client: container.resolve(type: NetworkClient.self, name: "dataClient"))
        )
        container.register(type: HomeModel.self, component: HomeModel(container: container))
        container.register(type: HomeViewModel.self, component: HomeViewModel(model: container.resolve(type: HomeModel.self)))
    }
}
