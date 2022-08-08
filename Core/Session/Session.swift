//
//  Session.swift
//  Core
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

final public class Session: AuthorizationCredentialsProvider {
    
    public var authorizationToken: String {
        "0cd74bf29e43ef1ad6afd6861cc99eb2"
    }
    public var authorizationType: AuthType {
        .appIdQueryAPIKey
    }
    
    public init() {}
}
