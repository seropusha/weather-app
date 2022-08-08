//
//  APIRequest.swift
//  Core
//
//  Created by Serhii Navka on 23.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public protocol APIRequest {
    
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

public extension APIRequest {
    
    var method: HTTPMethod { return .get }
    var parameters: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
}
