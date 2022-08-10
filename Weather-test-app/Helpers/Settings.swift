//
//  Settings.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Combine

extension Settings {
    private static let temperatureMeasureType = "tempeature-measure-type"
}

public final class Settings {
    
    private let storage: CodableKeyValueStorage
    
    init(storage: CodableKeyValueStorage = UserDefaults.standard) {
        self.storage = storage
    }
    
    var currentMeasureType: Temperature {
        storage.object(forKey: Self.temperatureMeasureType) ?? .celsius
    }
    
    var publisherMeasureType: AnyPublisher<Temperature, Never> {
        storage.publisher(key: Self.temperatureMeasureType)
    }
    
    func update(measureType: Temperature) {
        storage.setObject(measureType, forKey: Self.temperatureMeasureType)
    }
}

