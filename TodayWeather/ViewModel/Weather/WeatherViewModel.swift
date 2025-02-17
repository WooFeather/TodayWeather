//
//  WeatherViewModel.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import Foundation

final class WeatherViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private let words = WeatherWords.allCases
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void> = Observable(())
        let searchBarButtonItemTapped: Observable<Void> = Observable(())
        let refreshBarButtonItemTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        let searchBarButtonItemTapped: Observable<Void> = Observable(())
        let countryNameAndCityName: Observable<(String, String)> = Observable(("", ""))
        let dateString: Observable<String> = Observable("")
        let iconUrl: Observable<String> = Observable("")
        let imageUrl: Observable<String> = Observable("")
        let weatherWord: Observable<String> = Observable("")
        let cellStringList: Observable<[String]> = Observable([])
        let callRequest: Observable<Void> = Observable(())
    }
    
    // MARK: - Initializer
    init() {
        print("WeatherViewModel Init")
        
        input = Input()
        output = Output()
        transform()
    }
    
    deinit {
        print("WeatherViewModel Deinit")
    }
    
    // MARK: - Functions
    func transform() {
        input.viewWillAppearTrigger.lazyBind { [weak self] _ in
            self?.parseJSON()
            self?.callGroupWeatherAPI(id: "\(UserDefaultsManager.cityId)")
        }
        
        input.refreshBarButtonItemTapped.lazyBind { [weak self] _ in
            self?.callGroupWeatherAPI(id: "\(UserDefaultsManager.cityId)")
        }
        
        input.searchBarButtonItemTapped.bind { [weak self] _ in
            self?.output.searchBarButtonItemTapped.value = ()
        }
    }
    
    private func parseJSON() {
        guard let path = Bundle.main.path(forResource: "CityInfo", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        var city: City?
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let jsonData = try Data(contentsOf: url)
            city = try decoder.decode(City.self, from: jsonData)
            
            if let city = city {
                for index in 0..<city.cities.count {
                    if city.cities[index].id == UserDefaultsManager.cityId {
                        print("4️⃣ parsing", UserDefaultsManager.cityId)
                        output.countryNameAndCityName.value = (
                            city.cities[index].koCountryName,
                            city.cities[index].koCityName
                        )
                    }
                }
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    private func callGroupWeatherAPI(id: String) {
        NetworkManager.shared.callRequest(api: .groupSearch(id: id), type: GroupWeather.self) { [weak self] response in
            switch response {
            case .success(let value):
                let result = value.list[0]
                
                self?.output.dateString.value = Date().toStringUTC(result.time.timezone, format: "M월 d일(E) a h시 m분")
                
                let iconUrl = "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png"
                
                self?.output.iconUrl.value = iconUrl
                
                // weather word를 한글로 변환
                for i in 0..<(self?.words.count ?? 0) {
                    if result.weather[0].word == self?.words[i].rawValue {
                        self?.output.weatherWord.value = self?.words[i].koreanWord ?? ""
                    }
                }
                
                // cell에 들어갈 날씨 정보 초기화
                self?.output.cellStringList.value = []
                
                // 소수점 아래 자르기
                let currentTemp = String(format: "%.1f", result.main.temp)
                let lowTemp = String(format: "%.0f", result.main.tempMin)
                let highTemp = String(format: "%.0f", result.main.tempMax)
                let feelsLikeTemp = String(format: "%.0f", result.main.feelsLike)
                
                // 일출 및 일몰시간
                let sunriseTime = self?.convertingUTCtime(result.time.sunrise).toStringUTC(result.time.timezone, format: "a h시 m분")
                let sunsetTime = self?.convertingUTCtime(result.time.sunset).toStringUTC(result.time.timezone, format: "a h시 m분")
                
                // TODO: 텍스트 일부만 폰트 변경
                ["현재 온도는 \(currentTemp)° 입니다. 최저\(lowTemp)° 최고\(highTemp)°",
                 "체감 온도는 \(feelsLikeTemp)° 입니다.",
                 "\(self?.output.countryNameAndCityName.value.1 ?? "도시")의 일출 시각은 \(sunriseTime ?? ""), 일몰 시각은 \(sunsetTime ?? "") 입니다.",
                 "습도는 \(result.main.humidity)% 이고, 풍속은 \(result.wind.speed)m/s 입니다"
                ].forEach {
                    self?.output.cellStringList.value.append($0)
                }
                
                self?.callSearchPhotoAPI(query: result.weather[0].description)
                
                self?.output.callRequest.value = ()
            case .failure(let error):
                // TODO: Alert 띄우기
                print(error)
            }
        }
    }
    
    private func callSearchPhotoAPI(query: String) {
        NetworkManager.shared.callRequest(api: .searchPhoto(query: query), type: Photo.self) { [weak self] response in
            switch response {
            case .success(let value):
                self?.output.imageUrl.value = value.results[0].urls.thumb
            case .failure(let error):
                // TODO: Alert 띄우기
                print(error)
            }
        }
    }
    
//    private func findIndex(array: [CityDetail]) -> Int {
//        var arrayIndex: Int
//        
//        for index in 0..<array.count {
//            if array[index].id == output.selectedId.value {
//                arrayIndex = index
//            } else {
//                arrayIndex = 60
//            }
//        }
//        
//        return arrayIndex
//    }
    
    private func convertingUTCtime(_ dt: Int) -> Date {
        let timeInterval = TimeInterval("\(dt)")!
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
}
