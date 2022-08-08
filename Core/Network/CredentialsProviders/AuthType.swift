//
//  AuthType.swift
//  Core
//
//  Created by Serhii Navka on 24.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public enum AuthType {
    
    case appIdQueryAPIKey
    
    var key: String {
        switch self {
        case .appIdQueryAPIKey: return "appid"
        }
    }
    
    var valuePrefix: String? {
        switch self {
        case .appIdQueryAPIKey: return ""
        }
    }
}
