//
//  ApplicationFlowCoordinator.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import UIKit

final class ApplicationFlowCoordinator {
    
    private let container: DIContainer
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.container = .init()
    }
    
    func execute() {
        HomeAssembly.assembly(with: container)
        let controller: HomeViewController = .instantiate(storyboardName: "Main")
        controller.viewModel = container.resolve(type: HomeViewModel.self)
        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
