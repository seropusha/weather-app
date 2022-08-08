//
//  NetworkClient.swift
//  Core
//
//  Created by Serhii Navka on 24.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public protocol NetworkClient {
    
    func execute<T: ResponseParser>(
        _ request: APIRequest,
        parser: T
    ) async -> Result<T.Representation>
}
