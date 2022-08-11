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
        let homeModel = container.resolve(type: HomeModel.self)
        homeModel.eventDelegate = self
        controller.viewModel = HomeViewModel(model: homeModel)
        controller.searchResultsController = searchResultsController
        
        let navigationController = UINavigationController(rootViewController: controller)
        containerViewController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - HomeViewVontrollerEventDelegate

extension ApplicationFlowCoordinator: HomeModelEventDelegate {

    func home(_ controller: HomeModel, didSelect: CityStorable) {
        let model = CityWeatherDetailedModel(
            weatherService: container.resolve(type: WeatherService.self),
            city: didSelect,
            settings: container.resolve(type: Settings.self)
        )
        model.eventDelegate = self
        let viewModel = CityWeatherDetailedViewModel(model: model)
        let controller: CityWeatherDetailedViewController = .instantiate(storyboardName: "Main")
        controller.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: controller)
        containerViewController?.present(navigationController, animated: true)
    }
}

// MARK: - CityWeatherDetaileEventDelegate

extension ApplicationFlowCoordinator: CityWeatherDetaileEventDelegate {
    
    func detailed(_ controller: CityWeatherDetailedModel, shouldShowMapFor city: CityStorable) {
        guard let longtitue = city.longtitue,
                let latitude = city.latitude
        else { return }
        
        let controller: MapViewController = .instantiate(storyboardName: "Main")
        controller.model = MapModel(longtitude: longtitue, latitude: latitude)
        let navigationController = containerViewController?.presentedViewController as? UINavigationController
        navigationController?.pushViewController(controller, animated: true)
    }
}
