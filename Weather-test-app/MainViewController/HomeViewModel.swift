//
//  HomeViewModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel {
    
    private let model: HomeModel
    
    var querySubscriber: AnySubscriber<String, Never> {
        model.query
    }
    
    init(model: HomeModel) {
        self.model = model
    }
    
    func load() {
        model.load()
    }
}
