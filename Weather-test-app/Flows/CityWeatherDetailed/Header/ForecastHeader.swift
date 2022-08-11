//
//  ForecastHeader.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit

final class ForecastHeader: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func set(title: String) {
        self.titleLabel.text = title
    }
}
