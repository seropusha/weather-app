//
//  ViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 05.08.2022.
//

import UIKit
import Core

class HomeViewController: UIViewController {
    
    let session = Session()
    lazy var apiClient: NetworkClient = NetworkClientBuilder.build(
            serverBaseURL: URL(string: "http://api.openweathermap.org/")!,
            apiVersion: "geo/1.0",
            authorizationCredentialsProvider: session
        )
    
    lazy var apiClient2: NetworkClient = NetworkClientBuilder.build(
            serverBaseURL: URL(string: "http://api.openweathermap.org/")!,
            apiVersion: "data/2.5",
            authorizationCredentialsProvider: session
        )
    
    lazy var geocodingService: GeocidingService = .init(client: apiClient)
    lazy var weatherService: WeatherService = .init(client: apiClient2)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}

