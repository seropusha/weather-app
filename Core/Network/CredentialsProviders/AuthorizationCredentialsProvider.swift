//
//  AuthorizationCredentialsProvider.swift
//  Core
//
//  Created by Serhii Navka on 23.03.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

public protocol AuthorizationCredentialsProvider {
    
    var authorizationToken: String { get }
    var authorizationType: AuthType { get }
    
}
