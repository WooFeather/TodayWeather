//
//  WeatherViewModel.swift
//  TodayWeather
//
//  Created by 조우현 on 3/1/25.
//

import Foundation
import RxSwift
import RxCocoa

final class WeatherViewModel {
    
    private let disposeBag = DisposeBag()
    private let cityData = PublishRelay<[CityDetail]>()
    private let weatherData = PublishRelay<[Weather]>()
    private let photoData = PublishRelay<[PhotoDetail]>()
    
    struct Input {
        // viewWillAppear시 JSON파싱 및 네트워크통신
        let viewDidAppear: Observable<Bool>
        // refreshButtonTapped
        // searchButtonTapped
    }
    
    struct Output {
        // TableView에 보여줄 City데이터
        // TableView에 보여줄 Weather데이터
        // TableView에 보여줄 Photo데이터
        // refreshButtonTapped
        // searchButtonTapped
    }
    
    func transform(input: Input) -> Output {
        
        // TODO: viewDidAppear시 GroupWeatherAPI호출
        
        return Output()
    }
}
