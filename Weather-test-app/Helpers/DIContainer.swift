//
//  DIContainer.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation

protocol DIContainerProtocol {
    
    func register<Component>(type: Component.Type, name: String?, component: Any)
    func resolve<Component>(type: Component.Type, name: String?) -> Component
    
}

final class DIContainer: DIContainerProtocol {
    
    init() {}
    
    var components: [String: Any] = [:]
    
    func register<Component>(type: Component.Type, name: String?, component: Any) {
        if let name = name {
            components["\(type)-\(name)"] = component
        } else {
            components["\(type)"] = component
        }
    }
    func resolve<Component>(type: Component.Type, name: String?) -> Component {
        if let name = name {
            return components["\(type)-\(name)"] as! Component
        } else {
            return components["\(type)"] as! Component
        }
    }
    
    func register<Component>(type: Component.Type, component: Any) {
        register(type: type, name: nil, component: component)
    }
    
    func resolve<Component>(type: Component.Type) -> Component {
        resolve(type: type, name: nil)
    }
}
