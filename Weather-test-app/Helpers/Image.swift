//
//  Image.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 10.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit
import Kingfisher

public enum Image {
    public static let defaultPlaceholderImage: UIImage? = .init(named: "placeholder")
    
    case image(UIImage)
    case url(url: URL?, placeholder: UIImage? = Self.defaultPlaceholderImage)
}

extension UIImageView {
    
    public func setImage(_ image: Image) {
        switch image {
        case .image(let uIImage):
            self.image = uIImage
            
        case .url(let urlOptional, let placeholder):
            kf.setImage(with: urlOptional, placeholder: placeholder)
        }
    }
    
    public func cancelImageFetching() {
        kf.cancelDownloadTask()
    }
    
}
