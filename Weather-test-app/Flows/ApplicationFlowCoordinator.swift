//
//  ApplicationFlowCoordinator.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import UIKit
import Core

final class ApplicationFlowCoordinator {
    
    private let container: DIContainer
    private let window: UIWindow
    
    weak var containerViewController: UIViewController?
    
    init(window: UIWindow) {
        self.window = window
        self.container = .init()
    }
    
    func execute() {
        ApplicationAssembly.assembly(with: container)
        SearchResultsAssembly.assembly(with: container)
        HomeAssembly.assembly(with: container)
        
        let searchResultsController: SearchResultsController = .instantiate(storyboardName: "Main")
        searchResultsController.model = container.resolve(type:  SearchResultsModel.self)
        
        let controller: HomeViewController = .instantiate(storyboardName: "Main")
        controller.viewModel = container.resolve(type: HomeViewModel.self)
        controller.searchResultsController = searchResultsController
        controller.eventDelegate = self
        
        let navigationController = UINavigationController(rootViewController: controller)
        containerViewController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func buildDetailedCityWeather() -> UIViewController {
        .init()
    }
}

extension ApplicationFlowCoordinator: HomeViewVontrollerEventDelegate {
    
    func home(_ controller: HomeViewController, didSelect: CityStorable) {
        let model = CityWeatherDetailedModel(
            weatherService: container.resolve(type: WeatherService.self),
            city: didSelect,
            settings: container.resolve(type: Settings.self)
        )
        let viewModel = CityWeatherDetailedViewModel(model: model)
        let controller: CityWeatherDetailedViewController = .instantiate(storyboardName: "Main")
        controller.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: controller)
        containerViewController?.present(navigationController, animated: true)
    }
}
