//
//  ViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 05.08.2022.
//

import UIKit
import Core
import Combine

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    var searchResultController: SearchResultsController!
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: searchResultController)
        navigationItem.searchController = searchController
        setupBindings()
    }

    private func setupBindings() {
        searchController.searchBar.searchTextField
            .textPublisher
            .map { $0 == nil ? "" : $0! }
            .receive(subscriber: viewModel.querySubscriber)
    }

}

