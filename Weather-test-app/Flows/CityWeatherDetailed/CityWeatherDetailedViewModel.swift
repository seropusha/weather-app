//
//  CityWeatherDetailedViewModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core
import Combine

extension CityWeatherDetailedViewModel {
    enum Section {
        case weatherInfo(MainInfoWeatherCell.ViewModel)
        case forecast((Date, [WeatherItemCell.ViewModel]))
        
        var count: Int {
            switch self {
            case .weatherInfo:
                return 1
                
            case let .forecast((_, items)):
                return items.count
            }
        }
    }
}

final class CityWeatherDetailedViewModel {
    
    var title: String {
        model.title
    }
    var data: [(key: Date, value: [CurrentCityWeatherResponse])] {
        _data.value
    }
    var reload: AnyPublisher<Void, Never> {
        _data.map { _ in }
            .merge(with: model.$measureType.map { _ in })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var mesureType: Temperature {
        model.measureType
    }
    var measureTitle: AnyPublisher<String, Never> {
        model.$measureType.map { $0.switchToTitle }.eraseToAnyPublisher()
    }
    private let _data: CurrentValueSubject<[(key: Date, value: [CurrentCityWeatherResponse])], Never> = .init([])
    private let model: CityWeatherDetailedModel
    private var cancelBag: Set<AnyCancellable> = .init()
    
    init(model: CityWeatherDetailedModel) {
        self.model = model
        
        setupBindigs()
    }
    
    func toggleMeasureType() {
        model.toggleMeasureType()
    }
    
    func sendShowMapEvent() {
        model.sendShowMapEvent()
    }
    
    func load() {
        model.load()
    }
    
    func headerTitle(for sectionIndex: Int) -> String? {
        let section = buildSection(at: sectionIndex)
        switch section {
        case .weatherInfo:
            return nil
            
        case let .forecast((date, _)):
            return DateFormatter.day.string(from: date)
        }
    }
    
    func numbersOfSections() -> Int {
        guard !_data.value.isEmpty else { return 0 }
        
        return _data.value.count + 1
    }
    
    func numberOfItems(at sectionIndex: Int) -> Int {
        guard !_data.value.isEmpty else { return 0 }
        
        if sectionIndex == 0 {
            return 1
        } else if sectionIndex == 1 {
            return _data.value[sectionIndex - 1].value.count - 1
        } else {
            return _data.value[sectionIndex - 1].value.count
        }
    }
}

// MARK: - Private

extension CityWeatherDetailedViewModel {
    private func setupBindigs() {
        model.$forecastWeather
            .filter { $0 != nil }
            .map { $0! }
            .compactMap { [weak self] response -> [(key: Date, value: [CurrentCityWeatherResponse])] in
                guard let self = self else { return [] }
                
                return self.buildSortedItems(with: response.list)
            }
            .sink { [weak self] in
                self?._data.send($0)
            }.store(in: &cancelBag)
    }
}

// MARK: - Mappers

extension CityWeatherDetailedViewModel: TemperatureCalculable {
    
    func buildSection(at index: Int) -> Section {
        guard let mainInfo = data.first?.value.first else { return Section.forecast((Date(), [])) }
        
        if index == 0 {
            return .weatherInfo(mapToMainWeatherCell(with: mainInfo))
            
        } else if index == 1 {
            guard let items = data.first?.value,
                  !items.isEmpty,
                  let key = data.first?.key else {
                return Section.forecast((Date(), []))
            }
            
            let withoutMainItem = items.dropFirst()
            
            return .forecast((key, withoutMainItem.map(mapToForecastCell)))
        } else {
            let item = data[index - 1]
            
            return .forecast((item.key, item.value.map(mapToForecastCell)))
        }
    }
    
    private func buildSortedItems(with weatherItems: [CurrentCityWeatherResponse]) -> [(key: Date, value: [CurrentCityWeatherResponse])] {
        let dict = weatherItems.reduce(into: [Date: [CurrentCityWeatherResponse]]()) { partialResult, item in
            if let dateKey = partialResult.keys.first(where: { $0.hasSame(.day, as: item.dt)}) {
                var array = partialResult[dateKey]!
                array.append(item)
                partialResult.updateValue(array, forKey: dateKey)
            } else {
                partialResult.updateValue([item], forKey: item.dt)
            }
        }
        
        return dict.sorted { lhs, rhs in
            lhs.key < rhs.key
        }
    }
    
    private func mapToMainWeatherCell(with weatherItem: CurrentCityWeatherResponse) -> MainInfoWeatherCell.ViewModel {
        let maxTempString = calculatedString(kelvin: weatherItem.main.tempMax, to: mesureType)
        let currentTempString = calculatedString(kelvin: weatherItem.main.temp, to: mesureType)
        let minTempString = calculatedString(kelvin: weatherItem.main.tempMin, to: mesureType)
        let feelsLike = calculatedString(kelvin: weatherItem.main.feelsLike, to: mesureType)
        
        return MainInfoWeatherCell.ViewModel(
            cityName: "CITY NAME",
            currentTemperature: currentTempString,
            maxTemperate: "H: \(maxTempString)",
            minTemperature: "L: \(minTempString)",
            weatherImage: .url(url: weatherItem.weather.first?.icon.buildImageURL()),
            descriptionWeather: weatherItem.weather.first?.weatherDescription ?? "",
            feelsLike: "Feels like: \(feelsLike)",
            visability: "visability: \(weatherItem.visibility)",
            humadity: "humadity: \(weatherItem.main.humidity)",
            wind: "wind: \(weatherItem.wind.speed)"
        )
    }
    
    private func mapToForecastCell(with weatherItem: CurrentCityWeatherResponse) -> WeatherItemCell.ViewModel {
        let currentTempString = calculatedString(kelvin: weatherItem.main.temp, to: mesureType)
        
        return WeatherItemCell.ViewModel(
            temperatureString: currentTempString,
            weatherImage: .url(url: weatherItem.weather.first?.icon.buildImageURL()),
            description: weatherItem.weather.first?.weatherDescription ?? "",
            time: DateFormatter.time.string(from: weatherItem.dt)
        )
    }
}
