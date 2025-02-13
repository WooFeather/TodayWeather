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
        weatherView.pagingTableView.delegate = self
        weatherView.pagingTableView.dataSource = self
        weatherView.pagingTableView.register(PagingTableViewCell.self, forCellReuseIdentifier: PagingTableViewCell.id)
    }
    
    override func configureView() {
        navigationItem.title = "국가이름, 도시"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PagingTableViewCell.id, for: indexPath) as? PagingTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceHeight = UIScreen.main.bounds.height
        let navBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return deviceHeight - navBarHeight
    }
}
