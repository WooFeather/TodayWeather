//
//  IconTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/15/25.
//

import UIKit
import SnapKit

final class IconTableViewCell: BaseTableViewCell {
    
    static let id = "IconTableViewCell"
    
    private let roundBackgroundView = UIView()
    let weatherIcon = UIImageView()
    let weatherLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(roundBackgroundView)
        roundBackgroundView.addSubview(weatherIcon)
        roundBackgroundView.addSubview(weatherLabel)
    }
    
    override func configureLayout() {
        roundBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(12)
            make.trailing.lessThanOrEqualTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.top.leading.equalTo(roundBackgroundView).offset(12)
            make.size.equalTo(21)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.leading.equalTo(weatherIcon.snp.trailing).offset(12)
            make.verticalEdges.trailing.equalTo(roundBackgroundView).inset(12)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .white
        roundBackgroundView.layer.cornerRadius = 6
        
        weatherIcon.image = UIImage(systemName: "sun.snow.fill")
        
        weatherLabel.text = "오늘의 날씨는 맑음입니다"
        weatherLabel.numberOfLines = 2
        weatherLabel.font = .systemFont(ofSize: 17)
    }
}
