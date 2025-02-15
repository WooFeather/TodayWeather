//
//  PhotoTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/15/25.
//

import UIKit
import SnapKit

final class PhotoTableViewCell: BaseTableViewCell {
    
    static let id = "PhotoTableViewCell"
    
    private let roundBackgroundView = UIView()
    let photoLabel = UILabel()
    let todayPhoto = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(roundBackgroundView)
        roundBackgroundView.addSubview(photoLabel)
        roundBackgroundView.addSubview(todayPhoto)
    }
    
    override func configureLayout() {
        roundBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(12)
            make.trailing.lessThanOrEqualTo(contentView).inset(12)
            make.bottom.equalTo(contentView)
        }
        
        photoLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(roundBackgroundView).inset(12)
        }
        
        todayPhoto.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(roundBackgroundView).inset(12)
            make.bottom.equalTo(roundBackgroundView).offset(-12)
            make.height.equalTo(200)
        }
    }
    
    override func configureView() {
        roundBackgroundView.backgroundColor = .white
        roundBackgroundView.layer.cornerRadius = 6
        
        photoLabel.text = "오늘의 사진"
        photoLabel.font = .systemFont(ofSize: 17)
        
        todayPhoto.image = .sample
        todayPhoto.contentMode = .scaleAspectFill
        todayPhoto.layer.cornerRadius = 6
        todayPhoto.clipsToBounds = true
    }
}
