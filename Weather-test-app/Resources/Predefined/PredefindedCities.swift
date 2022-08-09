//
//  PredefindedCities.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 09.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public struct PredefindedCities: Codable {
    
    public var cities: [[String: Int]] = []

    public static let `default`: PredefindedCities = PredefindedCities(named: "PredefindedCities") ?? PredefindedCities()
}

extension PredefindedCities {
    
    public init?(named name: String, in bundle: Bundle = .main) {
        if let url = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let value = try? PropertyListDecoder().decode(PredefindedCities.self, from: data) {
            self = value
        } else {
            return nil
        }
    }
}
