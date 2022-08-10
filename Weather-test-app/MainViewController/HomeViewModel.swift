//
//  HomeViewModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Combine
import UIKit
import Core

final class HomeViewModel {
    
    private let model: HomeModel
    
    var mesureType: Temperature {
        model.measureType
    }
    
    var querySubscriber: AnySubscriber<String, Never> {
        model.query
    }
    
    var cities: [CityStorable] {
        model.cities
    }
    
    var measureTitle: AnyPublisher<String, Never> {
        model.$measureType.map { $0.switchToTitle }.eraseToAnyPublisher()
    }
    
    var reload: AnyPublisher<Void, Never> {
        model.$cities.map { _ in }
            .merge(with: model.$weatherDict.map { _ in }, model.$measureType.map { _ in })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(model: HomeModel) {
        self.model = model
    }
    
    func weather(for city: CityStorable) -> CurrentCityWeatherResponse? {
        model.weatherDict[city]
    }
    
    func toggleMeasureType() {
        model.toggleMeasureType()
    }
}

extension HomeViewModel: TemperatureCalculable {
    func viewModel(at index: Int) -> HomeCityCell.ViewModel? {
        guard 0..<cities.count ~= index else { return nil }
        
        let city = cities[index]
        let weather = weather(for: city)
        
        return mapToViewModel(city: city, weather: weather)
    }
    
    func mapToViewModel(city: CityStorable, weather: CurrentCityWeatherResponse?) -> HomeCityCell.ViewModel {
        let weatherInfo = weather?.weather.first
        let maxTempString = calculatedString(kelvin: weather?.main.tempMax ?? 0, to: mesureType)
        let currentTempString = calculatedString(kelvin: weather?.main.temp ?? 0, to: mesureType)
        let minTempString = calculatedString(kelvin: weather?.main.tempMin ?? 0, to: mesureType)
        var timeString = ""
        if let timezone = weather?.timezone {
            let date = Date().addingTimeInterval(TimeInterval(timezone))
            timeString = DateFormatter.dayTime.string(from: date)
        }
        
        return HomeCityCell.ViewModel(
            weatherImage: .url(url: weatherInfo?.icon.buildImageURL()),
            cityName: city.name,
            weatherDescription: weatherInfo?.weatherDescription ?? "",
            maxTempString: "MAX: \(maxTempString)",
            currentTempString: "CURRENT: \(currentTempString)",
            minTempString: "MIN: \(minTempString)",
            currentTimeString: timeString,
            isLoading: weather == nil
        )
    }
}
