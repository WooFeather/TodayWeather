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
    private var weatherData = PublishRelay<[Weather]>()
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
        let weatherData: Driver<[Weather]>
        // TableView에 보여줄 Photo데이터
        // refreshButtonTapped
        // searchButtonTapped
    }
    
    func transform(input: Input) -> Output {
        
        // TODO: viewDidAppear시 GroupWeatherAPI호출
        input.viewDidAppear
            .flatMap { _ in
                NetworkManager.shared.callRequest(api: .groupSearch(id: "\(UserDefaultsManager.cityId)"), type: GroupWeather.self)
                    .catch { error in
                        let data = GroupWeather(cnt: 0, list: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, weather in
                owner.weatherData.accept(weather.list)
            }
            .disposed(by: disposeBag)
        
        
        return Output(weatherData: weatherData.asDriver(onErrorJustReturn: []))
    }
    
//    private func parseJSON() {
//        guard let path = Bundle.main.path(forResource: "CityInfo", ofType: "json") else { return }
//        let url = URL(fileURLWithPath: path)
//        
//        var city: City?
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        
//        do {
//            let jsonData = try Data(contentsOf: url)
//            city = try decoder.decode(City.self, from: jsonData)
//            
//            if let city = city {
//                let index = findIndex(array: city.cities)
//                
//                print("4️⃣ parsing", UserDefaultsManager.cityId)
//                
//                output.countryNameAndCityName.value = (
//                    city.cities[index].koCountryName,
//                    city.cities[index].koCityName
//                )
//            }
//        } catch {
//            print("ERROR: \(error)")
//        }
//    }
    
    private func findIndex(array: [CityDetail]) -> Int {
        var arrayIndex: Int = 60
        
        for index in 0..<array.count {
            if array[index].id == UserDefaultsManager.cityId {
                arrayIndex = index
            }
        }
        
        return arrayIndex
    }
}
