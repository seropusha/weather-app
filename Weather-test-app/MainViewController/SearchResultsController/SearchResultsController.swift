//
//  SearchResultsController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 08.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import UIKit
import Combine
import Core

final class SearchResultsController: UITableViewController {
    
    var model: SearchResultsModel!
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        let city = model.cities[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = city.name
        content.secondaryText = city.locationDescription
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = model.cities[indexPath.row]
        model.didSelect(city)
    }
    
    private func setupBindings() {
        model.reload.sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancelBag)
    }
}
