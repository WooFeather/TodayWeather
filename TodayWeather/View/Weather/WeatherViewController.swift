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
        weatherView.weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.id)
        weatherView.weatherTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.id)
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
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id, for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.id, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceHeight = UIScreen.main.bounds.height
        let navBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0) + 40 + 12
        return deviceHeight - navBarHeight
    }
}
