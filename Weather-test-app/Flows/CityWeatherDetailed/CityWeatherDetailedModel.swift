//
//  CityWeatherDetailedModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core
import Combine

final class CityWeatherDetailedModel: ObservableObject {
    
    @Published var forecastWeather: ForecastWeatherResponse?
    @Published var measureType: Temperature = .celsius
    var title: String {
        city.name
    }
    private let settings: Settings
    private let weatherService: WeatherService
    private let city: CityStorable
    private var cancelBag: Set<AnyCancellable> = .init()
    
    init(weatherService: WeatherService, city: CityStorable, settings: Settings) {
        self.weatherService = weatherService
        self.city = city
        self.settings = settings
        self.measureType = settings.currentMeasureType
        
        setupBindings()
    }
    
    func toggleMeasureType() {
        switch measureType {
        case .fahrenheit:
            settings.update(measureType: .celsius)
            
        case .celsius:
            settings.update(measureType: .fahrenheit)
        }
    }
    
    func load() {
        if let cityId = city.cityId {
            Task {
                let result = await weatherService.getForecastWeather(by: cityId)
                
                switch result {
                case .success(let weather):
                    forecastWeather = weather
                    
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        } else if let latitude = city.latitude,
                  let longtitude = city.longtitue {
            Task {
                let result = await weatherService.getForecastWeather(latitude: latitude, longtitude: longtitude)
                
                switch result {
                case .success(let weather):
                    forecastWeather = weather
                    
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Private

extension CityWeatherDetailedModel {
    private func setupBindings() {
        settings.publisherMeasureType.sink { [weak self] measureType in
            self?.measureType = measureType
        }
        .store(in: &cancelBag)
    }
}
