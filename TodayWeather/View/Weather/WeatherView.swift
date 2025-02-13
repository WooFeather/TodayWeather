//
//  WeatherView.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import SnapKit

final class WeatherView: BaseView {
    
    lazy var pagingTableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(pagingTableView)
    }
    
    override func configureLayout() {
        pagingTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        pagingTableView.isPagingEnabled = true
        pagingTableView.insetsLayoutMarginsFromSafeArea = false
        pagingTableView.backgroundColor = .brown
    }
}
