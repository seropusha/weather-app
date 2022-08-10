//
//  Temperature.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

enum Temperature: Codable {
    case fahrenheit
    case celsius
}

extension Temperature {
    var switchToTitle: String {
        switch self {
        case .celsius:
            return "switch to fahrenheits"
            
        case .fahrenheit:
            return "switch to celsius"
        }
    }
}

protocol TemperatureCalculable {
    func calculate(kelvin: Double, to measure: Temperature) -> Double
}

extension TemperatureCalculable {
    func calculate(kelvin: Double, to measure: Temperature) -> Double {
        switch measure {
        case .celsius:
            return kelvin - 273.15
            
        case .fahrenheit:
            return 9.0 / 5.0 * (kelvin - 273.15) + 32.0
        }
    }
    
    func calculatedString(kelvin: Double, to measure: Temperature) -> String {
        switch measure {
        case .fahrenheit:
            let value = calculate(kelvin: kelvin, to: measure)
            let formattedString = String(format: "%.1f", value)

            return "\(formattedString) °F"
            
        case .celsius:
            let value = calculate(kelvin: kelvin, to: measure)
            let formattedString = String(format: "%.1f", value)
            
            return "\(formattedString) °C"
        }
    }
}
