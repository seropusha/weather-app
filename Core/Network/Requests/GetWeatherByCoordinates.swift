//
//  GetWeatherByCoordinates.swift
//  Core
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

struct GetWeatherByCoordinates: APIRequest, AuthorizableRequest {
    let method: HTTPMethod = .get
    let path: String
    let encoding: ParameterEncoding = URLEncoding.default
    let parameters: [String: Any]?
    
    init(latitude: Double, longtitude: Double) {
        path = "weather"
        parameters = [
            "lat": latitude,
            "lon": longtitude
        ]
    }
}
