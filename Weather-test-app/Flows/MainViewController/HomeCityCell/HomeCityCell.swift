//
//  HomeCityCell.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 10.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit

extension HomeCityCell {
    struct ViewModel {
        let weatherImage: Image
        let cityName: String
        let weatherDescription: String
        let maxTempString: String
        let currentTempString: String
        let minTempString: String
        let currentTimeString: String
        let isLoading: Bool
    }
}

final class HomeCityCell: UITableViewCell {
    
    @IBOutlet private weak var weartherImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: ViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weartherImageView.cancelImageFetching()
    }

    private func setupViewModel() {
        weartherImageView.setImage(viewModel.weatherImage)
        cityNameLabel.text = viewModel.cityName
        weatherDescriptionLabel.text = viewModel.weatherDescription
        maxTempLabel.text = viewModel.maxTempString
        currentTempLabel.text = viewModel.currentTempString
        minTempLabel.text = viewModel.minTempString
        currentTimeLabel.text = viewModel.currentTimeString
        
        weatherDescriptionLabel.isHidden = viewModel.isLoading
        maxTempLabel.isHidden = viewModel.isLoading
        currentTempLabel.isHidden = viewModel.isLoading
        minTempLabel.isHidden = viewModel.isLoading
        currentTimeLabel.isHidden = viewModel.isLoading
        activityIndicator.isHidden = !viewModel.isLoading
        viewModel.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
