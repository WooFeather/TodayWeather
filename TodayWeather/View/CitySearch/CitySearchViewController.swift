//
//  CitySearchViewController.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit

final class CitySearchViewController: BaseViewController {
    
    private let citySearchView = CitySearchView()
    private let viewModel = CitySearchViewModel()
    
    // MARK: - Functions
    override func loadView() {
        view = citySearchView
    }
    
    override func configureView() {
        navigationItem.title = "도시 검색"
        citySearchView.emptyLabel.isHidden = true
    }
    
    override func configureData() {
        citySearchView.cityTableView.delegate = self
        citySearchView.cityTableView.dataSource = self
        citySearchView.cityTableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.id)
    }
}

// MARK: - Extension
extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
