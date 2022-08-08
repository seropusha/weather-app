//
//  HomeModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core
import Combine

final class HomeModel {
    
    private let weatherService: WeatherService
    private let settings: Settings
    private let searchResultsModel: SearchResultModel
    var query: AnySubscriber<String, Never> {
        searchResultsModel.querySubscriber
    }
    
    init(container: DIContainer) {
        self.settings = container.resolve(type: Settings.self)
        self.weatherService = container.resolve(type: WeatherService.self)
        self.searchResultsModel = container.resolve(type: SearchResultModel.self)
        
        searchResultsModel.didSelect = { selectedCity in
            print(selectedCity)
        }
    }
    
    func load() {
        Task {

        }
    }
    
}
