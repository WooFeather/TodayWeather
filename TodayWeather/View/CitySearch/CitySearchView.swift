//
//  CitySearchView.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import SnapKit

final class CitySearchView: BaseView {
    
    let citySearchBar = UISearchBar()
    let cityTableView = UITableView()
    let emptyLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(citySearchBar)
        addSubview(cityTableView)
        addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        citySearchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(citySearchBar.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cityTableView.snp.centerX)
            make.centerY.equalTo(cityTableView.snp.centerY).offset(-100)
            make.height.equalTo(16)
        }
    }
    
    override func configureView() {
        citySearchBar.placeholder = "지금, 날씨가 궁금한 곳은?"
        
        cityTableView.backgroundColor = .clear
        cityTableView.keyboardDismissMode = .onDrag
        cityTableView.separatorStyle = .none
        
        emptyLabel.text = "원하는 도시를 찾지 못했습니다."
        emptyLabel.font = .boldSystemFont(ofSize: 12)
    }
}
