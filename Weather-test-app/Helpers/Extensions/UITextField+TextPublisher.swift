//
//  UITextField+TextPublisher.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit
import Combine

extension UITextField {
    
    public var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map(\.object)
            .compactMap { $0 as? UITextField }
            .map(\.text)
            .eraseToAnyPublisher()
    }
}
