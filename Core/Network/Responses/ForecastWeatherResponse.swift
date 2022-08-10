//
//  ForecastWeatherResponse.swift
//  Core
//
//  Created by Serhii Navka on 10.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public struct ForecastWeatherResponse: Codable {
    public let list: [CurrentCityWeatherResponse]
    public let city: ForecastCityResponse
}

public struct ForecastCityResponse: Codable {
    public let sunset: Int
    public let country: String
    public let id: Int
    public let coordinates: Coordinates
    public let population: Int
    public let timezone: Int
    public let sunrise: Int
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case sunset
        case country
        case id
        case coordinates = "coord"
        case population
        case timezone
        case sunrise
        case name
    }
}
