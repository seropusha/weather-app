//
//  CityWeather.swift
//  Core
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

public struct CurrentCityWeatherResponse: Codable {
    public let id: Int
    public let coord: Coordinates
    public let weather: [Weather]
    public let base: String
    public let main: Main
    public let visibility: Int
    public let wind: Wind
    public let clouds: Clouds
    public let dt: Int
    public let sys: Sys
    public let timezone: Int
    public let name: String
}

public struct Clouds: Codable {
    public let all: Int
}

public struct Coordinates: Codable {
    public let longtitude: Double
    public let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longtitude = "lon"
        case latitude = "lat"
    }
}

public struct Main: Codable {
    public let temp: Double
    public let feelsLike: Double
    public let tempMin: Double
    public let tempMax: Double
    public let pressure: Int
    public let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

public struct Sys: Codable {
    public let type: Int
    public let id: Int
    public let country: String
    public let sunrise: Date
    public let sunset: Date
}

public struct Weather: Codable {
    public let id: Int
    public let main: String
    public let weatherDescription: String
    public let icon: IconId
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription = "description"
        case icon
    }
}

public struct Wind: Codable {
    public let speed: Double
    public let deg: Int
}
