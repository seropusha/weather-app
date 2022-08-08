//
//  UIViewController+instanstiate.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiate<T: UIViewController>(storyboardName: String) -> T! {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}
