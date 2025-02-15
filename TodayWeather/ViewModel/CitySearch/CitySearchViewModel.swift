//
//  CitySearchViewModel.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import Foundation

final class CitySearchViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        let cityList: Observable<[CityDetail]> = Observable([])
    }
    
    // MARK: - Initializer
    init() {
        print("CitySearchViewModel Init")
        
        input = Input()
        output = Output()
        transform()
    }
    
    deinit {
        print("CitySearchViewModel Deinit")
    }
    
    // MARK: - Functions
    func transform() {
        input.viewDidLoadTrigger.lazyBind { [weak self] _ in
            self?.parseJSON()
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
                output.cityList.value = city.cities
                
                // TODO: 여러 개의 id를 통한 callRequest
//                var cityIdList: [String] = []
//                cityIdList.append("\(city.cities[60].id)")
//                print(cityIdList)
//                // 베열 안의 id들을 ,로 이어진 string으로 변환
//                let idListString = cityIdList.joined(separator: ",")
//
                // 아래는 WeatherView를 위한 데이터 -> SearchCity용으로 변환 필요
//                output.countryNameAndCityName.value = (
//                    city.cities[60].koCountryName,
//                    city.cities[60].koCityName
//                )
//                callRequest(id: idListString)
            } else {
                print("데이터 파싱 실패")
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    private func callRequest(id: String) {
        let request = URLRequest(url: OpenWeatherRequest.groupSearch(id: id).endpoint)
        URLSession.shared.dataTask(with: request) { data, response, error in
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
            } else {
                print("data가 없거나 decoding실패")
            }
        }.resume()
    }
}
