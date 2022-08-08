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

protocol TemperatureCalculable {
    func calculate(fahrenheit: Double, to measure: Temperature) -> Double 
}

extension TemperatureCalculable {
    func calculate(fahrenheit: Double, to measure: Temperature) -> Double {
        switch measure {
        case .celsius:
            return (fahrenheit - 32) * 5 / 9
            
        case .fahrenheit:
            return fahrenheit
        }
    }
    
    func calculatedString(fahrenheit: Double, to measure: Temperature) -> String {
        switch measure {
        case .fahrenheit:
            return "\(calculate(fahrenheit: fahrenheit, to: measure)) °F"
            
        case .celsius:
            return "\(calculate(fahrenheit: fahrenheit, to: measure)) °C"
        }
    }
}
