//
//  WeatherViewController.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class WeatherViewController: BaseViewController {
    
    private let weatherView = WeatherView()
    private let disposeBag = DisposeBag()
    private let viewModel = WeatherViewModel()
    
    private let dpViewModel = DPWeatherViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dpViewModel.input.viewWillAppearTrigger.value = ()
    }
    
    // MARK: - Functions
    override func loadView() {
        view = weatherView
    }
    
    private func bind() {
        let input = WeatherViewModel.Input(
            viewDidAppear: rx.viewWillAppear
        )
        let output = viewModel.transform(input: input)
        
        output.weatherData
            .drive(weatherView.weatherTableView.rx.items(cellIdentifier: IconTableViewCell.id, cellType: IconTableViewCell.self)) { item, element, cell in
                let iconUrl = "https://openweathermap.org/img/wn/\(element.weather[0].icon)@2x.png"
                
                let weatherString = NSMutableAttributedString(string: "오늘의 날씨는 \(element.weather[0].word)입니다.")
                weatherString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 8, length: element.weather[0].word.count))
                
                cell.weatherIcon.kf.setImage(with: URL(string: iconUrl))
                cell.weatherLabel.attributedText = weatherString
            }
            .disposed(by: disposeBag)
    }
    
    override func bindData() {
        dpViewModel.output.searchBarButtonItemTapped.lazyBind { [weak self] _ in
            let vc = CitySearchViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        dpViewModel.output.countryNameAndCityName.bind { [weak self] (country, city) in
            self?.weatherView.titleLabel.text = "\(country), \(city)"
        }
        
        dpViewModel.output.callRequest.lazyBind { [weak self] _ in
            self?.weatherView.weatherTableView.reloadData()
        }
        
        dpViewModel.output.dateString.lazyBind { [weak self] text in
            self?.weatherView.weatherTableHeaderView.text = text
        }
        
        dpViewModel.output.imageUrl.lazyBind { [weak self] _ in
            self?.weatherView.weatherTableView.reloadData()
        }
    }
    
    override func configureData() {
//        weatherView.weatherTableView.delegate = self
//        weatherView.weatherTableView.dataSource = self
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
        dpViewModel.input.searchBarButtonItemTapped.value = ()
    }
    
    @objc
    private func refreshBarButtonItemTapped() {
        print(#function)
        dpViewModel.input.refreshBarButtonItemTapped.value = ()
    }
}

// MARK: - Extension

//extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        6
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: IconTableViewCell.id, for: indexPath) as? IconTableViewCell else { return UITableViewCell() }
//            
//            cell.weatherIcon.kf.setImage(with: URL(string: dpViewModel.output.iconUrl.value))
//            
//            let weatherString = NSMutableAttributedString(string: "오늘의 날씨는 \(dpViewModel.output.weatherWord.value)입니다.")
//            weatherString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 8, length: dpViewModel.output.weatherWord.value.count))
//            
//            cell.weatherLabel.attributedText = weatherString
//            
//            return cell
//        } else if indexPath.row == 5 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.id, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
//            
//            cell.todayPhoto.kf.setImage(with: URL(string: dpViewModel.output.imageUrl.value))
//            
//            return cell
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
//            
//            if indexPath.row == 1 {
//                let attributedText = NSMutableAttributedString(string: "현재 온도는 \(dpViewModel.output.currentTemp.value)° 입니다. 최저\(dpViewModel.output.lowTemp.value)° 최고\(dpViewModel.output.highTemp.value)°")
//                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 7, length: dpViewModel.output.currentTemp.value.count + 1))
//                attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray], range: NSRange(location: 7 + dpViewModel.output.currentTemp.value.count + 7, length: dpViewModel.output.lowTemp.value.count + dpViewModel.output.highTemp.value.count + 7))
//                
//                cell.weatherLabel.attributedText = attributedText
//            } else if indexPath.row == 2 {
//                let attributedText = NSMutableAttributedString(string: "체감 온도는 \(dpViewModel.output.feelsLikeTemp.value)° 입니다.")
//                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 7, length: dpViewModel.output.feelsLikeTemp.value.count + 1))
//                
//                cell.weatherLabel.attributedText = attributedText
//            } else if indexPath.row == 3 {
//                let attributedText = NSMutableAttributedString(string: "\(dpViewModel.output.countryNameAndCityName.value.1)의 일출 시각은 \(dpViewModel.output.sunriseTime.value), 일몰 시각은 \(dpViewModel.output.sunsetTime.value) 입니다.")
//                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: dpViewModel.output.countryNameAndCityName.value.1.count + 9, length: dpViewModel.output.sunriseTime.value.count))
//                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: dpViewModel.output.countryNameAndCityName.value.1.count + 9 + dpViewModel.output.sunriseTime.value.count + 9, length: dpViewModel.output.sunriseTime.value.count))
//                
//                cell.weatherLabel.attributedText = attributedText
//            } else {
//                let attributedText = NSMutableAttributedString(string: "습도는 \(dpViewModel.output.humidity.value)% 이고, 풍속은 \(dpViewModel.output.windSpeed.value)m/s 입니다")
//                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 4, length: String(dpViewModel.output.humidity.value).count + 1))
//                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: NSRange(location: 4 + String(dpViewModel.output.humidity.value).count + 10, length: String(dpViewModel.output.windSpeed.value).count + 3))
//                
//                cell.weatherLabel.attributedText = attributedText
//            }
//            
//            return cell
//        }
//    }
//}
