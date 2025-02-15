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
        viewModel.output.cityList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.id, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.output.cityList.value[indexPath.row]
        
        cell.configureData(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.cityList.value[indexPath.row]
        viewModel.input.didSelectRowAt.value = data.id
    }
}
