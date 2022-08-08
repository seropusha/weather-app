//
//  NetworkClientBuilder.swift
//  Core
//
//  Copyright © 2018 Navka. All rights reserved.
//

import Foundation

public struct NetworkClientBuilder {
    
    public static func build(
        serverBaseURL: URL,
        apiVersion: String,
        authorizationCredentialsProvider: AuthorizationCredentialsProvider
    ) -> NetworkClient {
        
        let networkClient = APIClient(
            host: serverBaseURL,
            plugins: [
                ErrorPreprocessorPlugin(errorPreprocessor: ErrorResponseProcessor()),
                AuthorizationPlugin(
                    provider: authorizationCredentialsProvider,
                    authErrorResolving: ErrorResponseProcessor.authErrorResolving()
                ),
                VersioningPlugin(defaultAPIVersion: apiVersion),
                PrettyLoggingPlugin(outputClosure: { Logger.verbose($0) })
            ]
        )
        
        return networkClient
    }
}
