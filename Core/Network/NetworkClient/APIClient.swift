//
//  APIClient.swift
//  Core
//
//  Created by Serhii Navka on 23.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case incorrectURL
    case unauthorized(String? = nil)
    case internalServer
    case wrongResponseProtocol
    case unhandledError(statusCode: Int, data: Data)
}

open class APIClient: NetworkClient {
        
    private let host: URL
    private let plugins: [PluginType]
    private let session: URLSession
    
    public init(
        host: URL,
        configuration: URLSessionConfiguration = .default,
        plugins: [PluginType]
    ) {
        self.host = host
        self.session = URLSession(configuration: configuration)
        self.plugins = plugins
    }
    
    public func execute<T: ResponseParser>(
        _ request: APIRequest,
        parser: T
    ) async -> Result<T.Representation> {
        await _execute(request, parser: parser, produce: { urlRequest in
            try await session.data(for: urlRequest)
        })
    }
}

// MARK: - Private

extension APIClient {
    
    private func _execute<T: ResponseParser>(
        _ request: APIRequest,
        parser: T,
        produce: (URLRequest) async throws -> (Data, URLResponse)
    ) async -> Result<T.Representation> {
        do {
            let request = prepare(request: request)
            
            let url = try buildURL(host: host.absoluteString, path: request.path)
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpMethod = request.method.rawValue
            urlRequest = try request.encoding.encode(urlRequest, with: request.parameters)
            urlRequest.httpShouldHandleCookies = false

            willSend(request: request)

            let (data, response) = try await produce(urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.wrongResponseProtocol
            }
            didReceive(response, data: data)
            try process(response, data: data)
            var parsed = try parser.parse(data)
            parsed = process(result: parsed)
            
            return .success(parsed)
        } catch {
            let error = decorate(error: error)
            
            if await isResolved(error: error) {
                // if error resolved by plugin call request again,
                // for example refresh session on 401 status code.
                return await _execute(request, parser: parser, produce: produce)
            }
            
            return .failure(error)
        }
    }
    
    private func buildURL(
        host: String,
        path: String
    ) throws -> URL {
        guard let url = URL(string: host + path) else {
            throw NetworkError.incorrectURL
        }
        return url
    }
}

// MARK: - Plugins support

private extension APIClient {
    
    func process<T>(result: T) -> T {
        plugins.reduce(result) { $1.process($0) }
    }
    
    func isResolved(error: Error) async -> Bool {
        if let plugin = plugins.first(where: { $0.canResolve(error) }) {
            return await plugin.isResolved(error)
        } else {
            return false
        }
    }
    
    func didReceive(_ response: HTTPURLResponse, data: Data) {
        plugins.forEach { $0.didReceive(response, data: data) }
    }
    
    func process(_ response: HTTPURLResponse, data: Data) throws {
        for plugin in plugins {
            if let error = plugin.processError(response, data: data) {
                throw error
            }
        }
    }
    
    func willSend(request: APIRequest) {
        plugins.forEach { $0.willSend(request) }
    }
    
    func prepare(request: APIRequest) -> APIRequest {
        plugins.reduce(request) { $1.prepare($0) }
    }
    
    func decorate(error: Error) -> Error {
        plugins.reduce(error) { $1.decorate($0) }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "Wrong URL"
            
        case .internalServer:
            return "Internal server error"
            
        case .unauthorized(let serverMessage):
            return serverMessage ?? "Unauthorised access"
            
        case .wrongResponseProtocol:
            return "Wrong response protocol look up in APIClient implementation"
            
        case let .unhandledError(statusCode, data):
            #if DEBUG
            return """
            unhandled network error
            status code: \(statusCode)
            response:
            \(data.prettyString)
            """
            #else
            return """
            unhandled network error
            status code: \(statusCode)
            """
            #endif

        }
    }
}
