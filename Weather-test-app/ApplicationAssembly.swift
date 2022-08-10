//
//  ApplicationAssembly.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Core

final class ApplicationAssembly {
    
    static func assembly(with container: DIContainer) {
        container.register(type: CodableKeyValueStorage.self, component: UserDefaults.standard)
        container.register(type: Settings.self, component: Settings(storage: container.resolve(type: CodableKeyValueStorage.self)))
        container.register(type: Session.self, component: Session())
    }
}
