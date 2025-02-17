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
        let selectedId: Observable<Int> = Observable(1835848) // TODO: UserDefaults에 저장된 id 사용
        let dateString: Observable<String> = Observable("")
        let iconUrl: Observable<String> = Observable("")
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
            self?.receiveId()
            self?.parseJSON()
            self?.callGroupWeatherAPI(id: "\(self?.output.selectedId.value ?? 1835848)")
        }
        
        input.refreshBarButtonItemTapped.lazyBind { [weak self] _ in
            self?.callGroupWeatherAPI(id: "\(self?.output.selectedId.value ?? 1835848)")
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
                    if city.cities[index].id == output.selectedId.value {
                        print("4️⃣ parsing", output.selectedId.value)
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
        NetworkManager.shared.callOpenWeatherAPI(api: .groupSearch(id: id), type: GroupWeather.self) { [weak self] response in
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
                
//                print(self?.output.cellStringList.value ?? "")
                self?.output.callRequest.value = ()
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
    
    // TODO: id를 받아온 이후, UserDefaults에 저장하고, 추후에 데이터 파싱시 UserDefaults에 저장된 id 사용
    private func receiveId() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(idReceivedNotification),
            name: Notification.Name("IdReceived"),
            object: nil
        )
    }
    
    @objc
    private func idReceivedNotification(value: NSNotification) {
        if let id = value.userInfo!["idValue"] as? Int {
            output.selectedId.value = id
            print("3️⃣ receive success", output.selectedId.value)
        } else {
            output.selectedId.value = 1835848
            print("3️⃣ receive fail", output.selectedId.value)
        }
    }
    
    private func convertingUTCtime(_ dt: Int) -> Date {
        let timeInterval = TimeInterval("\(dt)")!
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
}
