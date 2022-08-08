//
//  VersioningPlugin.swift
//  Core
//
//  Copyright © 2018 Navka. All rights reserved.
//

protocol VersionableAPIRequest {
    
    var apiVersion: String { get }
}

final class VersioningPlugin: PluginType {
    
    private let defaultAPIVersion: String
    
    init(defaultAPIVersion: String) {
        self.defaultAPIVersion = defaultAPIVersion
    }
    
    public func prepare(_ request: APIRequest) -> APIRequest {
        let proxyRequest = APIRequestProxy(request: request)
        let version: String
        
        if let versionableRequest = request as? VersionableAPIRequest {
            version = versionableRequest.apiVersion
        } else {
            version = defaultAPIVersion
        }
        proxyRequest.path = version + "/" + request.path
        
        return proxyRequest
    }
}
