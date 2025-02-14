//
//  TestTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/14/25.
//

import UIKit
import SnapKit

final class TestTableViewCell: BaseTableViewCell {
    
    static let id = "TestTableViewCell"
    
    let roundBackgroundView = UIView()
    let weatherLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(roundBackgroundView)
        roundBackgroundView.addSubview(weatherLabel)
    }
    
    override func configureLayout() {
        roundBackgroundView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
            make.height.equalTo(50)
            make.width.lessThanOrEqualTo(contentView).inset(12)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
            make.width.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .white
        DispatchQueue.main.async {
            self.roundBackgroundView.layer.cornerRadius = self.roundBackgroundView.frame.width / 20
        }
        
        weatherLabel.text = "오늘의 날씨는 맑음 입니다"
        weatherLabel.font = .systemFont(ofSize: 17)
    }
}
