//
//  WeatherView.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import SnapKit

final class WeatherView: BaseView {
    
//    lazy var weatherTableView = UITableView()
    private let weatherScrollView = UIScrollView()
    private let contentView = UIView()
    let weatherTableView = UITableView()
    let forecastView = UIView()
    let titleLabel = UILabel()

    
    override func configureHierarchy() {
        addSubview(titleLabel)
//        addSubview(weatherTableView)
        addSubview(weatherScrollView)
        weatherScrollView.addSubview(contentView)
        contentView.addSubview(weatherTableView)
        contentView.addSubview(forecastView)
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
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(weatherScrollView.snp.height)
        }
        
        forecastView.snp.makeConstraints { make in
            make.top.equalTo(weatherTableView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(weatherScrollView.snp.height)
            make.bottom.equalTo(contentView)
        }
        
//        weatherTableView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalToSuperview()
//            make.height.equalTo(weatherScrollView.snp.height)
//        }
        
//        weatherTableView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(12)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
    }
    
    override func configureView() {
        titleLabel.text = "국가이름, 도시"
        titleLabel.font = .boldSystemFont(ofSize: 36)
        
        weatherScrollView.backgroundColor = .brown
        weatherScrollView.isPagingEnabled = true
        weatherScrollView.showsVerticalScrollIndicator = false
//        weatherScrollView.contentSize = CGSize(width: self.frame.width, height: weatherScrollView.frame.height * CGFloat(pages.count))
//        
//        for (index, page) in pages.enumerated() {
//            page.frame = CGRect(
//                x: 0,
//                y: weatherScrollView.frame.height * CGFloat(index),
//                width: weatherScrollView.frame.width,
//                height: weatherScrollView.frame.height
//            )
//            weatherScrollView.addSubview(page)
//        }
        
        forecastView.backgroundColor = .gray
        
        weatherTableView.backgroundColor = .red
        weatherTableView.isScrollEnabled = false
        
//        weatherTableView.isPagingEnabled = true
//        weatherTableView.showsVerticalScrollIndicator = false
//        weatherTableView.separatorStyle = .none
//        weatherTableView.backgroundColor = .clear
    }
}
