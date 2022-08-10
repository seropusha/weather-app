//
//  ViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 05.08.2022.
//

import UIKit
import Core
import Combine

class HomeViewController: UITableViewController {
    
    var viewModel: HomeViewModel!
    var searchResultsController: SearchResultsController!
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        navigationItem.searchController = searchController
        setupBindings()
    }

    private func setupBindings() {
        searchController.searchBar.searchTextField
            .textPublisher
            .map { $0 == nil ? "" : $0! }
            .receive(subscriber: viewModel.querySubscriber)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: HomeCityCell.self),
            for: indexPath
        ) as! HomeCityCell
        
        return cell
    }
}
