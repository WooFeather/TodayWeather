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
        let callRequest: Observable<Void> = Observable(())
        
        let currentTemp: Observable<String> = Observable("")
        let lowTemp: Observable<String> = Observable("")
        let highTemp: Observable<String> = Observable("")
        let feelsLikeTemp: Observable<String> = Observable("")
        let sunriseTime: Observable<String> = Observable("")
        let sunsetTime: Observable<String> = Observable("")
        let humidity: Observable<Int> = Observable(-1)
        let windSpeed: Observable<Double> = Observable(0.0)
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
                
                // 소수점 아래 자르기
                self?.output.currentTemp.value = String(format: "%.1f", result.main.temp)
                self?.output.lowTemp.value = String(format: "%.0f", result.main.tempMin)
                self?.output.highTemp.value = String(format: "%.0f", result.main.tempMax)
                self?.output.feelsLikeTemp.value = String(format: "%.0f", result.main.feelsLike)
                
                // 일출 및 일몰시간
                self?.output.sunriseTime.value = self?.convertingUTCtime(result.time.sunrise).toStringUTC(result.time.timezone, format: "a h시 m분") ?? ""
                self?.output.sunsetTime.value = self?.convertingUTCtime(result.time.sunset).toStringUTC(result.time.timezone, format: "a h시 m분") ?? ""
                
                self?.output.humidity.value = result.main.humidity
                self?.output.windSpeed.value = result.wind.speed
                
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
    
    private func convertingUTCtime(_ dt: Int) -> Date {
        let timeInterval = TimeInterval("\(dt)")!
        let utcTime = Date(timeIntervalSince1970: timeInterval)
        return utcTime
    }
}
