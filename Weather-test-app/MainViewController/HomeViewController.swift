//
//  ViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 05.08.2022.
//

import UIKit
import Core

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.load()
    }


}

