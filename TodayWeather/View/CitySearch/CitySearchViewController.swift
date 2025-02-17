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
        
        viewModel.output.searchButtonClicked.lazyBind { [weak self] _ in
            self?.view.endEditing(true)
        }
        
        viewModel.output.filteredCityList.lazyBind { [weak self] _ in
            self?.citySearchView.cityTableView.reloadData()
        }
        
        viewModel.output.isTableViewHidden.lazyBind { [weak self] status in
            self?.citySearchView.cityTableView.isHidden = status
        }
        
        viewModel.output.isEmptyLabelHidden.lazyBind { [weak self] status in
            self?.citySearchView.emptyLabel.isHidden = status
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
        citySearchView.citySearchBar.delegate = self
    }
}

// MARK: - Extension
extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.filteredCityList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        
        print("CITY", viewModel.output.filteredCityList.value.count)
        print("WEATHER", viewModel.output.weatherList.value.count)
        
        let cityData = viewModel.output.filteredCityList.value[indexPath.row]
        cell.configureCityData(cityData: cityData)
        
        if viewModel.output.weatherList.value.count == viewModel.output.filteredCityList.value.count {
            let weatherData = viewModel.output.weatherList.value[indexPath.row]
            cell.configureWeatherData(weatherData: weatherData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.filteredCityList.value[indexPath.row]
        viewModel.input.didSelectRowAt.value = data.id
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.input.searchTextDidChange.value = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchButtonClicked.value = searchBar.text
    }
}
