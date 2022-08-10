//
//  DateFormatters.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 10.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// Format: "EEEE" (Ex. "Friday")
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter
    }()
    
    /// Format: "EEEE, , HH:mm" (Ex. "Friday, 10:33")
    static let dayTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        return formatter
    }()
}
