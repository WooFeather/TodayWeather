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
            self?.weatherView.weatherTableView.reloadData()
        }
        
        viewModel.output.dateString.lazyBind { [weak self] text in
            self?.weatherView.weatherTableHeaderView.text = text
        }
        
        viewModel.output.imageUrl.lazyBind { [weak self] _ in
            self?.weatherView.weatherTableView.reloadData()
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
            
            let weatherString = NSMutableAttributedString(string: "오늘의 날씨는 \(viewModel.output.weatherWord.value)입니다.")
            weatherString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 8, length: viewModel.output.weatherWord.value.count))
            
            cell.weatherLabel.attributedText = weatherString
            
            return cell
        } else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.id, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
            
            cell.todayPhoto.kf.setImage(with: URL(string: viewModel.output.imageUrl.value))
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            
            if indexPath.row == 1 {
                let attributedText = NSMutableAttributedString(string: "현재 온도는 \(viewModel.output.currentTemp.value)° 입니다. 최저\(viewModel.output.lowTemp.value)° 최고\(viewModel.output.highTemp.value)°")
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 7, length: viewModel.output.currentTemp.value.count + 1))
                attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray], range: NSRange(location: 7 + viewModel.output.currentTemp.value.count + 7, length: viewModel.output.lowTemp.value.count + viewModel.output.highTemp.value.count + 7))
                
                cell.weatherLabel.attributedText = attributedText
            } else if indexPath.row == 2 {
                let attributedText = NSMutableAttributedString(string: "체감 온도는 \(viewModel.output.feelsLikeTemp.value)° 입니다.")
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 7, length: viewModel.output.feelsLikeTemp.value.count + 1))
                
                cell.weatherLabel.attributedText = attributedText
            } else if indexPath.row == 3 {
                let attributedText = NSMutableAttributedString(string: "\(viewModel.output.countryNameAndCityName.value.1)의 일출 시각은 \(viewModel.output.sunriseTime.value), 일몰 시각은 \(viewModel.output.sunsetTime.value) 입니다.")
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: viewModel.output.countryNameAndCityName.value.1.count + 9, length: viewModel.output.sunriseTime.value.count))
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: viewModel.output.countryNameAndCityName.value.1.count + 9 + viewModel.output.sunriseTime.value.count + 9, length: viewModel.output.sunriseTime.value.count))
                
                cell.weatherLabel.attributedText = attributedText
            } else {
                let attributedText = NSMutableAttributedString(string: "습도는 \(viewModel.output.humidity.value)% 이고, 풍속은 \(viewModel.output.windSpeed.value)m/s 입니다")
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 4, length: String(viewModel.output.humidity.value).count + 1))
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 4 + String(viewModel.output.humidity.value).count + 10, length: String(viewModel.output.windSpeed.value).count + 3))
                
                cell.weatherLabel.attributedText = attributedText
            }
            
            return cell
        }
    }
}
