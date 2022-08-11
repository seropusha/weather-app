//
//  MainInfoWeatherCell.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit

extension MainInfoWeatherCell {
    struct ViewModel {
        let cityName: String
        let currentTemperature: String
        let maxTemperate: String
        let minTemperature: String
        let weatherImage: Image
        let descriptionWeather: String
        let feelsLike: String
        let visability: String
        let humadity: String
        let wind: String
    }
}

final class MainInfoWeatherCell: UICollectionViewCell {
    
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var maxTenperatureLabel: UILabel!
    @IBOutlet private weak var minTenperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var visabilityLabel: UILabel!
    @IBOutlet private weak var humadityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    
    var viewModel: ViewModel! {
        didSet {
            configure()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherImageView.cancelImageFetching()
    }
}

// MARK: - Private

extension MainInfoWeatherCell {
    private func configure() {
        currentTemperatureLabel.text = viewModel.currentTemperature
        weatherImageView.setImage(viewModel.weatherImage)
        descriptionLabel.text = viewModel.descriptionWeather
        maxTenperatureLabel.text = viewModel.maxTemperate
        currentTemperatureLabel.text = viewModel.currentTemperature
        minTenperatureLabel.text = viewModel.minTemperature
        feelsLikeLabel.text = viewModel.feelsLike
        visabilityLabel.text = viewModel.visability
        humadityLabel.text = viewModel.humadity
        windLabel.text = viewModel.wind
    }
}
