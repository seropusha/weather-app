//
//  WeatherItemCell.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import UIKit

extension WeatherItemCell {
    
    struct ViewModel {
        let temperatureString: String
        let weatherImage: Image
        let description: String
        let time: String
    }
}

final class WeatherItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    
    var viewModel: ViewModel! {
        didSet {
            configure()
        }
    }
}

// MARK: - Private

extension WeatherItemCell {
    private func configure() {
        temperatureLabel.text = viewModel.temperatureString
        weatherImageView.setImage(viewModel.weatherImage)
        descriptionLabel.text = viewModel.description
        timeLabel.text = viewModel.time
    }
}
