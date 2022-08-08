//
//  AccessCredentialsProvider.swift
//  Core
//
//  Created by Serhii Navka on 23.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

/// Describes required entity for `RequestDecorationPlugin`
public protocol AccessCredentialsProvider: AnyObject {
    
    var accessToken: String? { get set }
    var exchangeToken: String? { get set }
    
    /// Method for update your credential
    ///
    /// - Parameter update: closure with new credentials
    func commitCredentialsUpdate(_ update: (AccessCredentialsProvider) -> Void)
    
    /// Called in case of not successful update
    func invalidate()
}

extension AccessCredentialsProvider {
    
    // this app hasn't exhange token
    public var exchangeToken: String? {
        get { nil }
        set { _ = newValue }
    }
}
