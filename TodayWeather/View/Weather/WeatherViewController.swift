//
//  WeatherViewController.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import Kingfisher

final class WeatherViewController: BaseViewController {
    
    private let weatherView = WeatherView()
    private let viewModel = WeatherViewModel()
    
    // MARK: - Functions
    override func loadView() {
        view = weatherView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.viewWillAppearTrigger.value = ()
    }
    
    override func bindData() {
        viewModel.output.searchBarButtonItemTapped.lazyBind { [weak self] _ in
            let vc = CitySearchViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.output.countryNameAndCityName.bind { [weak self] (country, city) in
            self?.weatherView.titleLabel.text = "\(country), \(city)"
        }
        
        viewModel.output.callRequest.lazyBind { [weak self] _ in
            DispatchQueue.main.async {
                self?.weatherView.weatherTableView.reloadData()
            }
        }
        
        viewModel.output.dateString.lazyBind { [weak self] text in
            DispatchQueue.main.async {
                self?.weatherView.weatherTableHeaderView.text = text
            }
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
        viewModel.input.refreshBarButtonItemTapped.value = ()
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
            
            cell.weatherIcon.kf.setImage(with: URL(string: viewModel.output.iconUrl.value))
            
            cell.weatherLabel.text = "오늘의 날씨는 \(viewModel.output.weatherWord.value)입니다."
            
            return cell
        } else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.id, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            
            if viewModel.output.cellStringList.value.isEmpty {
                cell.weatherLabel.text = ""
            } else {
                let data = viewModel.output.cellStringList.value[indexPath.row - 1]
                cell.weatherLabel.text = data
            }
            
            return cell
        }
    }
}
