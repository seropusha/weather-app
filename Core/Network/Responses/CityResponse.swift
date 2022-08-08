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
    public let localNames: LocalNames?
    public let latitude: Double
    public let longtitue: Double
    public let country: String?
    public let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case latitude = "lat"
        case longtitue = "lon"
        case country
        case state
    }
}

public struct LocalNames: Codable {
    public let nl: String?
    public let ru: String?
    public let wa: String?
    public let fr: String?
    public let la: String?
    public let li: String?
    public let en: String?
    public let vi: String?
    public let zh: String?
    public let ko: String?
    public let de: String?
    public let et: String?
    public let mk: String?
    public let cs: String?
    public let ka: String?
    public let be: String?
    public let ar: String?
    public let bg: String?
    public let hy: String?
    public let sr: String?
    public let hu: String?
    public let uk: String?
    public let es: String?
}
