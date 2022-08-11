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
import Collections

protocol HomeModelEventDelegate: AnyObject {
    func home(_ controller: HomeModel, didSelect: CityStorable)
}

final class HomeModel: ObservableObject {
    
    weak var eventDelegate: HomeModelEventDelegate?
    @Published var measureType: Temperature = .celsius
    @Published var cities: [CityStorable] = []
    @Published var weatherDict: [CityStorable: CurrentCityWeatherResponse] = [:]
    var query: AnySubscriber<String, Never> {
        searchResultsModel.querySubscriber
    }
    private let weatherService: WeatherService
    private let settings: Settings
    private let searchResultsModel: SearchResultsModel
    private let storage: CodableKeyValueStorage
    private var cancelBag: Set<AnyCancellable> = .init()
    
    init(container: DIContainer) {
        self.storage = container.resolve(type: CodableKeyValueStorage.self)
        self.settings = container.resolve(type: Settings.self)
        self.weatherService = container.resolve(type: WeatherService.self)
        self.searchResultsModel = container.resolve(type: SearchResultsModel.self)
        
        setupBindings()
        setupPredifinedCitiesToStoreIfNeeded()
        setupSelectCityCallbackFromSearch()
        self.cities = currentStoredCities ?? []
        self.measureType = settings.currentMeasureType
    }
    
    func toggleMeasureType() {
        switch measureType {
        case .fahrenheit:
            settings.update(measureType: .celsius)
            
        case .celsius:
            settings.update(measureType: .fahrenheit)
        }
    }
    
    func showDetailedWeather(for city: CityStorable) {
        eventDelegate?.home(self, didSelect: city)
    }
}

// MARK: - Private

extension HomeModel {
    private func setupSelectCityCallbackFromSearch() {
        searchResultsModel.didSelect = { [weak self] selectedCity in
            self?.storeSelected(city: selectedCity)
        }
    }
    
    private func setupBindings() {
        settings.publisherMeasureType.sink { [weak self] measureType in
            self?.measureType = measureType
        }
        .store(in: &cancelBag)
        
        let storedCitiesPublisher: AnyPublisher<[CityStorable], Never> = storage.publisher(key: Self.citiesStoreKey)
        storedCitiesPublisher
            .sink { [weak self] storedCities in
                self?.cities = storedCities
            }
            .store(in: &cancelBag)
        
        $cities.sink { [weak self] cities in
            guard let self = self else { return }
            
            let citiesToDownload = Set(self.weatherDict.keys).symmetricDifference(Set(cities))
            if !citiesToDownload.isEmpty {
                self.fetchWeather(for: Array(citiesToDownload))
            }
        }.store(in: &cancelBag)
    }
}

// MARK: - Load weather

extension HomeModel {
    
    private func fetchWeather(for cities: [CityStorable]) {
        Task {
            do {
                let downloadedWeathers = try await fetchWeathers(for: cities)
                var updatedWeathers = self.weatherDict
                
                downloadedWeathers.forEach {
                    updatedWeathers.updateValue($0.value, forKey: $0.key)
                }
                self.weatherDict = updatedWeathers
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchWeathers(for cities: [CityStorable]) async throws -> [CityStorable: CurrentCityWeatherResponse] {
        return try await withThrowingTaskGroup(of: (CityStorable, CurrentCityWeatherResponse).self) { group in
            var weathers: [CityStorable: CurrentCityWeatherResponse] = [:]
            
            for city in cities {
                group.addTask {
                    let result = await self.loadWeather(for: city)
                    
                    switch result {
                    case .success(let weather):
                        return (city, weather)
                        
                    case .failure(let error):
                        throw error
                    }
                }
            }
            
            for try await args in group {
                weathers.updateValue(args.1, forKey: args.0)
            }
            
            return weathers
        }
    }
    
    private func loadWeather(for city: CityStorable) async -> Result<CurrentCityWeatherResponse> {
        if let cityId = city.cityId {
            return await weatherService.getWeather(by: cityId)
            
        } else if let longtitude = city.longtitue,
                  let latitude = city.latitude {
            return await weatherService.getWeather(latitude: latitude, longtitude: longtitude)
        } else {
            preconditionFailure("City hasn't data for fetch weather")
        }
    }
}

// MARK: - Store cities

extension HomeModel {
    
    static private let citiesStoreKey: String = "cities-key"
    
    var currentStoredCities: [CityStorable]? {
        storage.object(forKey: Self.citiesStoreKey)
    }
    
    private func setupPredifinedCitiesToStoreIfNeeded() {
        if currentStoredCities == nil {
            let citiesForSave = PredefindedCities.default.cities
                .compactMap { (dict: [String: Int]) -> CityStorable? in
                    if let name = dict.keys.first,
                       let cityId = dict.values.first {
                        
                        return CityStorable(name: name, cityId: cityId)
                    } else {
                        return nil
                    }
                }
            
            storage.setObject(citiesForSave, forKey: Self.citiesStoreKey)
        }
    }
    
    private func storeSelected(city: CityResponse) {
        guard
            let storedCities = storage.object(forKey: Self.citiesStoreKey) as [CityStorable]?,
            !storedCities.isEmpty
        else {
            return
        }
        
        let storedCity = CityStorable(
            name: city.name ?? "",
            latitude: city.latitude,
            longtitue: city.longtitue,
            country: city.country,
            state: city.state
        )
        let set = OrderedSet([storedCity] + storedCities)
        storage.setObject(Array(set), forKey: Self.citiesStoreKey)
    }
}
