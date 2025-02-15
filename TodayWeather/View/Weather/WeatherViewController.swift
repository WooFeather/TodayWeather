//
//  WeatherViewController.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit

final class WeatherViewController: BaseViewController {
    
    private let weatherView = WeatherView()
    private let viewModel = WeatherViewModel()
    
    // MARK: - Functions
    override func loadView() {
        view = weatherView
    }
    
    override func bindData() {
        viewModel.output.searchBarButtonItemTapped.lazyBind { [weak self] _ in
            let vc = CitySearchViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func configureData() {
        weatherView.weatherTableView.delegate = self
        weatherView.weatherTableView.dataSource = self
        weatherView.weatherTableView.register(IconTableViewCell.self, forCellReuseIdentifier: IconTableViewCell.id)
        weatherView.weatherTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.id)
        weatherView.weatherTableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.id)
    }
    
    override func configureView() {
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchBarButtonItemTapped))
        let refreshBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(refreshBarButtonItemTapped))
        navigationItem.setRightBarButtonItems([searchBarButtonItem, refreshBarButtonItem], animated: true)
    }
    
    // MARK: - Actions
    @objc
    private func searchBarButtonItemTapped() {
        print(#function)
        viewModel.input.searchBarButtonItemTapped.value = ()
    }
    
    @objc
    private func refreshBarButtonItemTapped() {
        print(#function)
        // TODO: 현재 날씨를 업데이트
    }
}

// MARK: - Extension

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IconTableViewCell.id, for: indexPath) as? IconTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.id, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
}
