//
//  WeatherView.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import SnapKit

final class WeatherView: BaseView {
    
    lazy var weatherTableView = UITableView()
    let titleLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(weatherTableView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(16)
            make.height.equalTo(40)
        }
        
        weatherTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        titleLabel.text = "국가이름, 도시"
        titleLabel.font = .boldSystemFont(ofSize: 36)
        
        weatherTableView.isPagingEnabled = true
        weatherTableView.showsVerticalScrollIndicator = false
        weatherTableView.separatorStyle = .none
        weatherTableView.backgroundColor = .clear
    }
}
