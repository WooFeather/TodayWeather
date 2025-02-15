//
//  TextTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/14/25.
//

import UIKit
import SnapKit

final class TextTableViewCell: BaseTableViewCell {
    
    static let id = "TextTableViewCell"
    
    private let roundBackgroundView = UIView()
    let weatherLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(roundBackgroundView)
        roundBackgroundView.addSubview(weatherLabel)
    }
    
    override func configureLayout() {
        roundBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(12)
            make.trailing.lessThanOrEqualTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.edges.equalTo(roundBackgroundView).inset(12)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .white
        roundBackgroundView.layer.cornerRadius = 6
        
        weatherLabel.text = "체감온도는 88도입니다"
        weatherLabel.numberOfLines = 2
        weatherLabel.font = .systemFont(ofSize: 17)
    }
}
