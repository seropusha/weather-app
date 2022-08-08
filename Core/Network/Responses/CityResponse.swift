//
//  CityResponse.swift
//  Core
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public struct CityResponse: Codable {
    public let name: String?
    public let latitude: Double
    public let longtitue: Double
    public let country: String?
    public let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longtitue = "lon"
        case country
        case state
    }
}

extension CityResponse {
    public var locationDescription: String {
        var country = country ?? ""
        
        if let state = state {
            country += " / \(state)"
        }
        
        return country
    }
}
