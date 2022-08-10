//
//  WeatherService.swift
//  Core
//
//  Created by Serhii Navka on 05.08.2022.
//

import Foundation

public final class WeatherService {
    
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func getWeather(by cityId: Int) async -> Result<CurrentCityWeatherResponse> {
        let request = GetWeatherByCityId(cityId: cityId)
        let parser = DecodableParser<CurrentCityWeatherResponse>()
        
        return await client.execute(request, parser: parser)
    }
    
    public func getWeather(latitude: Double, longtitude: Double) async -> Result<CurrentCityWeatherResponse> {
        let request = GetWeatherByCoordinates(latitude: latitude, longtitude: longtitude)
        let parser = DecodableParser<CurrentCityWeatherResponse>()
        
        return await client.execute(request, parser: parser)
    }
}
