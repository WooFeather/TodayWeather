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
            self?.callRequest(id: "\(self?.output.selectedId.value ?? 1835848)")
        }
        
        input.refreshBarButtonItemTapped.lazyBind { [weak self] _ in
            self?.callRequest(id: "\(self?.output.selectedId.value ?? 1835848)")
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
                
                // TODO: index찾는 로직 함수화
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
    
    private func callRequest(id: String) {
        let request = URLRequest(url: OpenWeatherRequest.groupSearch(id: id).endpoint)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            print(request.url ?? "URL 없음")
            if let error = error {
                // TODO: Alert띄우기
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                // TODO: 상태코드 대응
                print(response ?? "")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let data = data,
               let weatherData = try? decoder.decode(GroupWeather.self, from: data) {
                dump(weatherData)
                let result = weatherData.list[0]
                
                self?.output.dateString.value = Date().toStringUTC(result.time.timezone)
                
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
                
                // TODO: 텍스트 일부만 폰트 변경
                ["현재 온도는 \(result.main.temp)° 입니다. 최저\(result.main.tempMin) 최고\(result.main.tempMax)",
                 "체감 온도는 \(result.main.feelsLike)° 입니다.",
                 "\(self?.output.countryNameAndCityName.value.1 ?? "도시")의 일출 시각은 \(result.time.sunrise), 일몰 시각은 \(result.time.sunset) 입니다.",
                 "습도는 \(result.main.humidity)% 이고, 풍속은 \(result.wind.speed)m/s 입니다"
                ].forEach {
                    self?.output.cellStringList.value.append($0)
                }
                
                print(self?.output.cellStringList.value ?? "")
            } else {
                print("data가 없거나 decoding실패")
            }
            
            self?.output.callRequest.value = ()
        }.resume()
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
//            return arrayIndex
//        }
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
}
