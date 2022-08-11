//
//  ViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 05.08.2022.
//

import UIKit
import Core
import Combine

protocol HomeViewVontrollerEventDelegate: AnyObject {
    func home(_ controller: HomeViewController, didSelect: CityStorable)
}

class HomeViewController: UITableViewController {
    
    weak var eventDelegate: HomeViewVontrollerEventDelegate?
    var viewModel: HomeViewModel!
    var searchResultsController: SearchResultsController!
    private var searchController: UISearchController!
    private var cancelBag: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"
        searchResultsController.delegate = self
        searchController = UISearchController(searchResultsController: searchResultsController)
        navigationItem.searchController = searchController
        setupBindings()        
    }
    
    // MARK: - Actions
    
    @objc
    private func toggleMeasure(_ sender: UIBarButtonItem) {
        viewModel.toggleMeasureType()
    }
    
    // MARK: - Private

    private func setupBindings() {
        searchController.searchBar.searchTextField
            .textPublisher
            .map { $0 == nil ? "" : $0! }
            .receive(subscriber: viewModel.querySubscriber)
        
        viewModel.reload.sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancelBag)
        
        viewModel.measureTitle.sink { [weak self] in
            self?.setupMeasureBarButton(title: $0)
        }.store(in: &cancelBag)
    }
    
    private func setupMeasureBarButton(title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(toggleMeasure)
        )
    }    
}

// MARK: - UITableViewDataSource && UITAbleViewDelegate


extension HomeViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        92.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: HomeCityCell.self),
            for: indexPath
        ) as! HomeCityCell
        
        cell.viewModel = viewModel.viewModel(at: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = viewModel.cities[indexPath.row]
        eventDelegate?.home(self, didSelect: city)
    }
}

// MARK: - SearchResultsControllerDelegate

extension HomeViewController: SearchResultsControllerDelegate {
    
    func searchResultsShouldHide(_ controller: SearchResultsController) {
        searchController.isActive = false
    }
}
