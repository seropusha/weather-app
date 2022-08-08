//
//  SearchCityByQueryRequest.swift
//  Core
//
//  Created by Serhii Navka on 08.07.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public struct SearchCityByQueryRequest: APIRequest, AuthorizableRequest {
    public let method: HTTPMethod = .get
    public let path: String
    public let encoding: ParameterEncoding = URLEncoding.default
    public let parameters: [String: Any]?
    
    public init(city: String, limit: Int) {
        path = "direct"
        parameters = [
            "q": city,
            "limit": limit
        ]
    }
}
