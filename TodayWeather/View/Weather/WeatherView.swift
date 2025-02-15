//
//  WeatherView.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import SnapKit

final class WeatherView: BaseView {
    
    private let weatherScrollView = UIScrollView()
    private let contentView = UIView()
    let weatherTableView = UITableView()
    let weatherTableHeaderView = UILabel()
    let weatherTableFooterView = UIButton()
    let forecastView = UIView()
    let titleLabel = UILabel()

    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(weatherScrollView)
        weatherScrollView.addSubview(contentView)
        [weatherTableView, forecastView, weatherTableHeaderView, weatherTableFooterView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(16)
            make.height.equalTo(40)
        }
        
        weatherScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(weatherScrollView.snp.width)
            make.verticalEdges.equalTo(weatherScrollView)
        }
        
        weatherTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(weatherScrollView)
        }
        
        forecastView.snp.makeConstraints { make in
            make.top.equalTo(weatherTableView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(contentView)
            make.height.equalTo(weatherScrollView)
        }
        
        weatherTableHeaderView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        
        weatherTableFooterView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            // 이부분을 contentView나 tableView의 bottom으로 잡으면 안되네..
            make.bottom.equalTo(forecastView.snp.top).offset(-40)
        }
    }
    
    override func configureView() {
        titleLabel.text = "국가이름, 도시"
        titleLabel.font = .boldSystemFont(ofSize: 36)
        
        weatherScrollView.backgroundColor = .clear
        weatherScrollView.isPagingEnabled = true
        weatherScrollView.showsVerticalScrollIndicator = false
        
        weatherTableHeaderView.text = "8월 88일(목) 오후 88시 88분"
        weatherTableHeaderView.font = .boldSystemFont(ofSize: 17)
        
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.title = "5일간 예보 보러가기"
        config.image = UIImage(systemName: "chevron.down.2")
        config.imagePlacement = .leading
        config.buttonSize = .small
        weatherTableFooterView.configuration = config
        weatherTableFooterView.tintColor = .black
        
        weatherTableView.separatorStyle = .none
        weatherTableView.backgroundColor = .clear
        weatherTableView.isScrollEnabled = false
        weatherTableView.tableHeaderView = weatherTableHeaderView
        weatherTableView.tableFooterView = weatherTableFooterView
        weatherTableHeaderView.layoutIfNeeded()
        weatherTableFooterView.layoutIfNeeded()
        
        forecastView.backgroundColor = .clear
    }
}
