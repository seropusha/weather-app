//
//  SearchResultModel.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Core
import Combine

final class SearchResultsModel: ObservableObject {
    
    @Published var cities: [CityResponse] = []
    var reload: AnyPublisher<Void, Never> {
        $cities
            .map { _ in }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var querySubscriber: AnySubscriber<String, Never> {
        AnySubscriber(query)
    }
    var didSelect: (CityResponse) -> Void = { _ in }
    private let geocodingService: GeocidingService
    private let query: CurrentValueSubject<String, Never> = .init("")
    private var cancelBag: Set<AnyCancellable> = .init()
    
    init(container: DIContainer) {
        self.geocodingService = container.resolve(type: GeocidingService.self)
        
        setupBindings()
    }
    
    
    func shouldStartSearch(with query: String) -> Bool {
        query.count > 1
    }
    
    private func setupBindings() {
        query
            .filter(shouldStartSearch)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] query in
                self?.fetchCities(with: query)
            })
            .store(in: &cancelBag)
    }
    
    private func fetchCities(with query: String) {
        Task {
            let result = await geocodingService.search(query)
            
            switch result {
            case .success(let cities):
                self.cities = cities
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
