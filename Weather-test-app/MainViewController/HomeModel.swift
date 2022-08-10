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

struct CityStorable: Codable, Hashable {
    let name: String
    let latitude: Double?
    let longtitue: Double?
    let country: String?
    let state: String?
    let cityId: Int?
    
    init(name: String, cityId: Int) {
        self.name = name
        self.latitude = nil
        self.longtitue = nil
        self.country = nil
        self.state = nil
        self.cityId = cityId
    }
    
    init(
        name: String,
        latitude: Double,
        longtitue: Double,
        country: String?,
        state: String?
    ) {
        self.name = name
        self.latitude = latitude
        self.longtitue = longtitue
        self.country = country
        self.state = state
        self.cityId = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

final class HomeModel: ObservableObject {
    
//    @Published var cities: [CityStorable] = []
    private let weatherService: WeatherService
    private let settings: Settings
    private let searchResultsModel: SearchResultsModel
    private let storage: CodableKeyValueStorage
    var weatherDict: [CityStorable: CurrentCityWeatherResponse] = [:]
    var query: AnySubscriber<String, Never> {
        searchResultsModel.querySubscriber
    }
    private var cancelBag: Set<AnyCancellable> = .init()
    
    init(container: DIContainer) {
        self.storage = container.resolve(type: CodableKeyValueStorage.self)
        self.settings = container.resolve(type: Settings.self)
        self.weatherService = container.resolve(type: WeatherService.self)
        self.searchResultsModel = container.resolve(type: SearchResultsModel.self)
        
        setupPredifinedCitiesToStoreIfNeeded()
        searchResultsModel.didSelect = { [weak self] selectedCity in
            self?.storeSelected(city: selectedCity)
        }
        observeCityChanges()
    }
    
}

extension HomeModel {
    func loadWeather(for city: CityStorable) {
        if let cityId = city.cityId {
            Task {
               let result = await weatherService.getWeather(by: cityId)
                
                switch result {
                case .success(let weatherResponse):
                    print(weatherResponse)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
            
        } else if let longtitude = city.longtitue,
                  let latitude = city.latitude {
            Task {
                let result = await weatherService.getWeather(latitude: latitude, longtitude: longtitude)
                
                switch result {
                case .success(let weatherResponse):
                    print(weatherResponse)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        } else {
            preconditionFailure("City hasn't data for fetch weather")
        }
    }
}

// MARK: - Store cities

extension HomeModel {
    
    static let citiesStoreKey: String = "cities-key"
    
    var currentStoredCities: [CityStorable]? {
        storage.object(forKey: Self.citiesStoreKey)
    }
    
    func observeCityChanges() {
        let storedCitiesPublisher: AnyPublisher<[CityStorable], Never> = storage.publisher(key: Self.citiesStoreKey, defaultValue: [])
        storedCitiesPublisher
            .sink { [weak self] storedCities in
//                self?.cities = storedCities
            }
            .store(in: &cancelBag)
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
