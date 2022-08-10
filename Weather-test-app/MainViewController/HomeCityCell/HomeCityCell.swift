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
        let minTempString: String
    }
}

final class HomeCityCell: UITableViewCell {
    
    @IBOutlet private weak var weartherImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    
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
        minTempLabel.text = viewModel.minTempString
    }
}
