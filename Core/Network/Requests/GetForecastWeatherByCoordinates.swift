//
//  GetForecastWeatherByCoordinates.swift
//  Core
//
//  Created by Serhii Navka on 10.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

struct GetForecastWeatherByCoordinates: APIRequest, AuthorizableRequest {
    let method: HTTPMethod = .get
    let path: String
    let encoding: ParameterEncoding = URLEncoding.default
    let parameters: [String: Any]?
    
    init(latitude: Double, longtitude: Double) {
        path = "forecast"
        parameters = [
            "lat": latitude,
            "lon": longtitude
        ]
    }
}
