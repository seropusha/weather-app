//
//  ErrorProcessingPLugin.swift
//  Core
//
//  Created by Serhii Navka on 24.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public struct AlreadyHandledError: Error {
    public let error: Error
}

public protocol ErrorProcessing {
    
    func processError(using httpResponse: HTTPURLResponse, data: Data) -> Error?
}

public final class ErrorPreprocessorPlugin: PluginType {

    private let errorPreprocessor: ErrorProcessing
    var notificationCenter: NotificationCenter = .default
    
    public init(errorPreprocessor: ErrorProcessing) {
        self.errorPreprocessor = errorPreprocessor
    }
    
    public func processError(_ httpResponse: HTTPURLResponse, data: Data) -> Error? {
        errorPreprocessor.processError(using: httpResponse, data: data)
    }
}
