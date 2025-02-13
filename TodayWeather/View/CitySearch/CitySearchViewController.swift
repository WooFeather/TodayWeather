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
        navigationItem.largeTitleDisplayMode = .never
    }
}
