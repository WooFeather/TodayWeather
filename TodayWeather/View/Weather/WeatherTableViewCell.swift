//
//  WeatherTableViewCell.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import UIKit
import SnapKit

final class WeatherTableViewCell: BaseTableViewCell {

    static let id = "WeatherTableViewCell"
    
    let dateLabel = UILabel()
    private let forecastButton = UIButton()
    lazy var weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func configureHierarchy() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherCollectionView)
        contentView.addSubview(forecastButton)
    }
    
    override func configureLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(contentView).offset(12)
            make.height.equalTo(21)
        }
        
        weatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(forecastButton.snp.top).offset(-16)
        }
        
        forecastButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-40)
            make.height.equalTo(17)
        }
    }
    
    override func configureView() {
        dateLabel.text = "8월 88일(목) 오후 88시 88분"
        dateLabel.font = .boldSystemFont(ofSize: 17)
        
        weatherCollectionView.backgroundColor = .brown
        
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.title = "5일간 예보 보러가기"
        config.image = UIImage(systemName: "chevron.down.2")
        config.imagePlacement = .leading
        config.buttonSize = .small
        forecastButton.configuration = config
        forecastButton.tintColor = .black
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        // TODO: Cell크기 동적조절
        layout.itemSize = CGSize(width: 200, height: 50)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing =  0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
}
