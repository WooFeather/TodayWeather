//
//  CityTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/14/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CityTableViewCell: BaseTableViewCell {

    static let id = "cityTableView"
    let roundBackgroundView = UIView()
    let cityLabel = UILabel()
    let countryLabel = UILabel()
    let lowTemperatureLabel = UILabel()
    let highTemperatureLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(roundBackgroundView)
        [cityLabel, countryLabel, lowTemperatureLabel, highTemperatureLabel, iconImageView, temperatureLabel].forEach {
            roundBackgroundView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        roundBackgroundView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.height.equalTo(21)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(17)
        }
        
        lowTemperatureLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalTo(contentView).offset(-12)
            make.height.equalTo(17)
        }
        
        highTemperatureLabel.snp.makeConstraints { make in
            make.leading.equalTo(lowTemperatureLabel.snp.trailing).offset(4)
            make.centerY.equalTo(lowTemperatureLabel.snp.centerY)
            make.height.equalTo(14)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(50)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(32)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .twCityBackground
        DispatchQueue.main.async {
            self.roundBackgroundView.layer.cornerRadius = self.roundBackgroundView.frame.width / 20
        }
        
        cityLabel.font = .boldSystemFont(ofSize: 17)
        
        countryLabel.font = .boldSystemFont(ofSize: 12)
        countryLabel.textColor = .gray
        
        lowTemperatureLabel.font = .boldSystemFont(ofSize: 12)
        lowTemperatureLabel.textColor = .gray
        
        highTemperatureLabel.font = .boldSystemFont(ofSize: 12)
        highTemperatureLabel.textColor = .gray
        
        iconImageView.contentMode = .scaleAspectFill
        
        temperatureLabel.font = .boldSystemFont(ofSize: 30)
    }
    
    func configureCityData(cityData: CityDetail) {
        cityLabel.text = cityData.koCityName
        countryLabel.text = cityData.koCountryName
    }
    
    func configureWeatherData(weatherData: Weather) {
        let currentTemp = String(format: "%.1f", weatherData.main.temp)
        let lowTemp = String(format: "%.0f", weatherData.main.tempMin)
        let highTemp = String(format: "%.0f", weatherData.main.tempMax)
        let iconUrl = "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png"
        
        lowTemperatureLabel.text = "최저 \(lowTemp)°"
        highTemperatureLabel.text = "최고 \(highTemp)°"
        iconImageView.kf.setImage(with: URL(string: iconUrl))
        temperatureLabel.text = "\(currentTemp)°"
    }
}
