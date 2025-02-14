//
//  ForecastTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit

final class ForecastTableViewCell: BaseTableViewCell {

    static let id = "ForecastTableViewCell"
    
    private let titleLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(21)
        }
    }
    
    override func configureView() {
        titleLabel.text = "5일간 예보입니다."
        titleLabel.font = .systemFont(ofSize: 17)
    }
}
