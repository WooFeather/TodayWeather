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
    
    override func bindData() {
        viewModel.input.viewDidLoadTrigger.value = ()
        
        viewModel.output.didSelectRowAt.lazyBind { [weak self] _ in
            print("2️⃣ pop")
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.output.weatherList.lazyBind { [weak self] _ in
            self?.citySearchView.cityTableView.reloadData()
        }
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
        return viewModel.output.weatherList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        
        let cityData = viewModel.output.cityList.value[indexPath.row]
        let weatherData = viewModel.output.weatherList.value[indexPath.row]
        
        cell.configureCityData(cityData: cityData)
        cell.configureWeatherData(weatherData: weatherData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.cityList.value[indexPath.row]
        viewModel.input.didSelectRowAt.value = data.id
    }
}

// TODO: 검색기능 구현
