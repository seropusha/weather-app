//
//  ErrorResponse.swift
//  Core
//
//  Copyright © 2018 Navka. All rights reserved.
//

import Foundation

public struct ErrorResponse: Error, Codable {
    public let message: String?
}

extension ErrorResponse: LocalizedError {
    public var errorDescription: String? {
        message
    }
}
