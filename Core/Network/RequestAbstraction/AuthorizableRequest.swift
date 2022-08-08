//
//  AuthorizableRequest.swift
//  Core
//
//  Created by Serhii Navka on 24.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

/// Adopt this protocol in order to be able to authorize your request
public protocol AuthorizableRequest {
    
    /// If true provides request with credentials from `RestorationTokenPlugin`
    var authorizationRequired: Bool { get }
}

extension AuthorizableRequest {
    
    public var authorizationRequired: Bool { return true }
}
