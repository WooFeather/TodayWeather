//
//  CityTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/14/25.
//

import UIKit
import SnapKit

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
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(32)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .twCityBackground
        DispatchQueue.main.async {
            self.roundBackgroundView.layer.cornerRadius = self.roundBackgroundView.frame.width / 20
        }
        
        cityLabel.text = "테스트"
        cityLabel.font = .boldSystemFont(ofSize: 17)
        
        countryLabel.text = "테스트나라입니다"
        countryLabel.font = .boldSystemFont(ofSize: 12)
        countryLabel.textColor = .gray
        
        lowTemperatureLabel.text = "최저 -8°"
        lowTemperatureLabel.font = .boldSystemFont(ofSize: 12)
        lowTemperatureLabel.textColor = .gray
        
        highTemperatureLabel.text = "최저 88°"
        highTemperatureLabel.font = .boldSystemFont(ofSize: 12)
        highTemperatureLabel.textColor = .gray
        
        iconImageView.image = UIImage(systemName: "cloud.sun.rain")
        
        temperatureLabel.text = "-88°"
        temperatureLabel.font = .boldSystemFont(ofSize: 30)
    }
}
