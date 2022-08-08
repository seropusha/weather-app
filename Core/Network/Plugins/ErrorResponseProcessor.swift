//
//  ErrorResponseProcessor.swift
//  Core
//
//  Copyright © 2018 Navka. All rights reserved.
//

import Foundation

struct ErrorResponseProcessor: ErrorProcessing {
    
    func processError(using httpResponse: HTTPURLResponse, data: Data) -> Error? {
        if let networkError = generalError(httpResponse.statusCode, data: data) {
            return networkError
        }
        
        switch httpResponse.statusCode {
        case 200..<299:
            return nil
            
        default:
            let serverError: ErrorResponse? = parseError(data: data)

            return serverError ?? NetworkError.unhandledError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    static func authErrorResolving() -> AuthErrorResolving {
        return { error in
            if let error = error as? NetworkError, case .unauthorized = error {
                return true
            }
            
            return false
        }
    }
    
    private func parseError<T: Decodable>(data: Data) -> T? {
        do {
            let parser = DecodableParser<T>()
            let serverError: T = try parser.parse(data)
            
            return serverError
        } catch {
            Logger.error("can't parse error with payload \(data.prettyString)")
            Logger.error(error: error)
        }
        
        return nil
    }
    
    private func generalError(_ code: Int, data: Data) -> Error? {
        switch code {
        case 401:
            let serverMessage: String?
            if let error: ErrorResponse = parseError(data: data) {
                serverMessage = error.localizedDescription
                
            } else {
                serverMessage = nil
            }

            return NetworkError.unauthorized(serverMessage)
            
        case 500:
            return NetworkError.internalServer
            
        default:
            return nil
        }
    }
    
}
