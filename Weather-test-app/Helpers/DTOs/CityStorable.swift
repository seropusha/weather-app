//
//  CityStorable.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 10.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

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
    
    mutating func update(latitude: Double, longtitude: Double) {
        self = CityStorable(
            name: name,
            latitude: latitude,
            longtitue: longtitude,
            country: country,
            state: state
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
