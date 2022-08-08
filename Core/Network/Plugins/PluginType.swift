//
//  PluginType.swift
//  Core
//
//  Created by Serhii Navka on 22.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

/// Describes functions of the plugin for APIClient
public protocol PluginType {

    /// Called to modify a request before sending
    func prepare(_ request: APIRequest) -> APIRequest
    
    /// Called immediately before a request is sent over the network.
    func willSend(_ request: APIRequest)
    
    /// Called immediately after data received.
    func didReceive(_ response: HTTPURLResponse, data: Data)
    
    func canResolve(_ error: Error) -> Bool
    
    /// Called to resolve error in case it happend.
    func isResolved(_ error: Error) async -> Bool
    
    /// Called to provide error in case response isn't successful.
    func processError(_ response: HTTPURLResponse, data: Data) -> Error?
    
    /// Called to modify a result in case of success right before completion.
    func process<T>(_ result: T) -> T
    
    /// Called to provide custom error type in case response isn't successful.
    func decorate(_ error: Error) -> Error
}

public extension PluginType {
    
    func prepare(_ request: APIRequest) -> APIRequest {
        return request
    }
    
    func willSend(_ request: APIRequest) {
    }
    
    func didReceive(_ response: HTTPURLResponse, data: Data) {
    }
    
    func canResolve(_ error: Error) -> Bool {
        return false
    }
    
    func isResolved(_ error: Error) async -> Bool {
        false
    }
    
    func processError(_ response: HTTPURLResponse, data: Data) -> Error? {
        return nil
    }
    
    func process<T>(_ result: T) -> T {
        return result
    }
    
    func decorate(_ error: Error) -> Error {
        return error
    }
}
