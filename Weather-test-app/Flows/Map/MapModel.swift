//
//  MapVodel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import CoreLocation

final class MapModel {
    
    let coordinates: CLLocationCoordinate2D
    
    init(longtitude: Double, latitude: Double) {
        coordinates = .init(latitude: latitude, longitude: longtitude)
    }
}
