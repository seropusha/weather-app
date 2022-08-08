//
//  HomeModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core

final class HomeModel {
    
    private let geocodingService: GeocidingService
    private let weatherService: WeatherService
    private let settings: Settings
    
    init(container: DIContainer) {
        self.settings = container.resolve(type: Settings.self)
        self.weatherService = container.resolve(type: WeatherService.self)
        self.geocodingService = container.resolve(type: GeocidingService.self)
    }
    
    func load() {
        Task {
            let result = await geocodingService.search("L")
            
            print(result)
        }
    }
    
}
