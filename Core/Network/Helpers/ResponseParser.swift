//
//  ResponseParser.swift
//  Core
//
//  Created by Serhii Navka on 23.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public protocol ResponseParser {
    
    associatedtype Representation
    
    func parse(_ data: Data) throws -> Representation
}

public let defaultDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
//    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()

// MARK: - DecodableParser

public final class DecodableParser<T: Decodable>: ResponseParser {
    
    public typealias Representation = T
    
    public let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = defaultDecoder) {
        self.decoder = decoder
    }
    
    public func parse(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}

// MARK: - EmptyParser

public final class EmptyParser: ResponseParser {

    public typealias Representation = Void
    
    public func parse(_ data: Data) throws {
        return ()
    }
}
