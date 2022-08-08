//
//  APIRequestProxy.swift
//  Core
//
//  Created by Serhii Navka on 22.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public class APIRequestProxy: APIRequest {
    
    public var path: String
    public var method: HTTPMethod
    public var encoding: ParameterEncoding
    public var parameters: [String: Any]?
    public var headers: [String: String]?
    
    public init(request: APIRequest, path: String? = nil, headers: [String: String]? = nil) {
        self.path = path ?? request.path
        method = request.method
        encoding = request.encoding
        parameters = request.parameters
        self.headers = headers ?? request.headers
    }
}
