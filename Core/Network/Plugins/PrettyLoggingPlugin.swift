//
//  PrettyLoggingPlugin.swift
//  Core
//
//  Created by Serhii Navka on 11.04.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public final class PrettyLoggingPlugin: PluginType {
    
    private let outputClosure: (String) -> Void
    
    public init(outputClosure: ((String) -> Void)? = nil) {
        if let outputClosure = outputClosure {
            self.outputClosure = outputClosure
        } else {
            self.outputClosure = { string in
                #if DEBUG
                print("----------------------------")
                print("PrettyLoggingPlugin [\(Date())]: \(string)")
                print("----------------------------")
                #endif
            }
        }
    }
    
    public func prepare(_ request: APIRequest) -> APIRequest {
        outputClosure("Preparing request")
        
        return request
    }
    
    public func willSend(_ request: APIRequest) {
        outputClosure("Ready to send - \(describe(request))")
    }
    
    public func didReceive(_ response: HTTPURLResponse, data: Data) {
        outputClosure("Received - \(describe(response, data: data))")
    }
    
    public func resolve(_ error: Error) -> Bool {
        outputClosure("Attempt to resolve - \(error)")
        
        return false
    }
    
    public func processError(_ response: HTTPURLResponse, data: Data) -> Error? {
        guard 200..<299 ~= response.statusCode else {
            outputClosure("Received error - \(describe(response, data: data))")
            return nil
        }
        
        return nil
    }
    
    public func decorate(_ error: Error) -> Error {
        outputClosure("Trying to decorate error - \(error)")
        
        return error
    }
    
    private func describe(_ request: APIRequest) -> String {
        #if DEBUG
        let httpMethod = request.method.rawValue.uppercased()
        return """
        \(request.path) 🚀 \(httpMethod)
        HEADERS: \(request.headers?.prettyString ?? "EMPTY HEADERS")
        PARAMETERS: \(request.parameters?.prettyString ?? "EMPTY PARAMETERS")
        ENCODING: \(type(of: request.encoding))
        """
        #else
        return ""
        #endif
    }
    
    private func describe(_ response: HTTPURLResponse, data: Data) -> String {
        #if DEBUG
        let urlString = response.url?.absoluteString ?? "unknown"
        let statusCode = response.statusCode
        let contentType = response.allHeaderFields["Content-Type"] ?? "unknown"
        let dataBytes = data.count
        return "⬇️" + "\n" +
        """
        URL: \(urlString)
        StatusCode: \(statusCode)
        ContentType: \(contentType)
        \(dataBytes) bytes
        \(data.prettyString)
        """
        #else
        return ""
        #endif
    }
}
