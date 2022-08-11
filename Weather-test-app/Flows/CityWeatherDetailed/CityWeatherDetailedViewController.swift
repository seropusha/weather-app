//
//  CityWeatherDetailedViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class CityWeatherDetailedViewController: UICollectionViewController {
    
    var viewModel: CityWeatherDetailedViewModel!
    private let layout = DetailedCompositionalLayout()
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        setupBindings()
        layout.delegate = self
        collectionView.collectionViewLayout = layout.build()
        viewModel.load()
    }
}

// MARK: - Actions
 
extension CityWeatherDetailedViewController {
    @objc
    private func toggleMeasure(_ sender: UIBarButtonItem) {
        viewModel.toggleMeasureType()
    }
}

// MARK: - Private

extension CityWeatherDetailedViewController {
    private func setupMeasureBarButton(title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(toggleMeasure)
        )
    }
    
    private func setupBindings() {
        viewModel.reload.sink { [weak self] in
            self?.collectionView.reloadData()
        }.store(in: &cancelBag)
        
        viewModel.measureTitle.sink { [weak self] in
            self?.setupMeasureBarButton(title: $0)
        }.store(in: &cancelBag)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension CityWeatherDetailedViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numbersOfSections()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.numberOfItems(at: section)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = viewModel.buildSection(at: indexPath.section)
        let cell: UICollectionViewCell
        switch section {
        case .weatherInfo(let viewModel):
            let mainCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MainInfoWeatherCell.self),
                for: indexPath
            ) as! MainInfoWeatherCell
            mainCell.viewModel = viewModel
            cell = mainCell

        case let .forecast((_, viewModels)):
            let mainCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: WeatherItemCell.self),
                for: indexPath
            ) as! WeatherItemCell
            mainCell.viewModel = viewModels[indexPath.item]
            cell = mainCell
        }

        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: ForecastHeader.self),
            for: indexPath
        ) as! ForecastHeader
        
        header.set(title: viewModel.headerTitle(for: indexPath.section) ?? "")
        
        return header
    }
    
}

// MARK: - DetailedCompositionalLayoutDelegate

extension CityWeatherDetailedViewController: DetailedCompositionalLayoutDelegate {
    
    func layout(_ layout: DetailedCompositionalLayout, sectionAt index: Int) -> DetailedCompositionalLayout.Section? {
        if index == 0 {
            return .topInfo
        } else {
            return .forecast
        }
    }
    
    func layout(
        _ layout: DetailedCompositionalLayout,
        shouldAddHeaderFor section: DetailedCompositionalLayout.Section,
        sectionIndex: Int
    ) -> Bool {
        return sectionIndex != 1
    }
}
