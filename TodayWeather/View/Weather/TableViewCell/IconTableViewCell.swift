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
            make.centerY.equalTo(roundBackgroundView.snp.centerY)
            make.leading.equalTo(roundBackgroundView.snp.leading).offset(8)
            make.size.equalTo(40)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.leading.equalTo(weatherIcon.snp.trailing)
            make.verticalEdges.trailing.equalTo(roundBackgroundView).inset(12)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .white
        roundBackgroundView.layer.cornerRadius = 6
        
        weatherIcon.contentMode = .scaleAspectFill
        
        weatherLabel.numberOfLines = 2
        weatherLabel.font = .systemFont(ofSize: 17)
    }
}
