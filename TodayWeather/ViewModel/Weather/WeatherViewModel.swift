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
//    private var cityIdList: [String]?
    private let words = WeatherWords.allCases
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void> = Observable(())
        let searchBarButtonItemTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        let searchBarButtonItemTapped: Observable<Void> = Observable(())
        let countryNameAndCityName: Observable<(String, String)> = Observable(("", ""))
        let selectedId: Observable<Int> = Observable(1835848) // TODO: UserDefaults에 저장된 id 사용
        let iconUrl: Observable<String> = Observable("")
        let weatherWord: Observable<String> = Observable("")
        let nowTemp: Observable<Double> = Observable(0.0)
        let lowTempAndHighTemp: Observable<(Double, Double)> = Observable((0.0, 0.0))
        let feelsLikeTemp: Observable<Double> = Observable(0.0)
        let sunriseAndSunsetTime: Observable<(Int, Int)> = Observable((-1, -1))
        let humidityAndWindSpeed: Observable<(Int, Double)> = Observable((-1, 0.0))
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
                
                let iconUrl = "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png"
                
                self?.output.iconUrl.value = iconUrl
                
                for i in 0..<(self?.words.count ?? 0) {
                    if result.weather[0].word == self?.words[i].rawValue {
                        self?.output.weatherWord.value = self?.words[i].koreanWord ?? ""
                    } else {
                        self?.output.weatherWord.value = "알 수 없음"
                    }
                }
                
                self?.output.nowTemp.value = result.main.temp
                self?.output.lowTempAndHighTemp.value = (
                    result.main.tempMax,
                    result.main.tempMin
                )
                self?.output.feelsLikeTemp.value = result.main.feelsLike
                self?.output.sunriseAndSunsetTime.value = (
                    result.time.sunrise,
                    result.time.sunset
                )
                self?.output.humidityAndWindSpeed.value = (
                    result.main.humidity,
                    result.wind.speed
                )
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
