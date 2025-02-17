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
    private var idListString = ""
    private var cityIdList: [String] = []
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void?> = Observable(nil)
        let didSelectRowAt: Observable<Int?> = Observable(nil)
        let searchTextDidChange: Observable<String?> = Observable("")
        let searchButtonClicked: Observable<String?> = Observable("")
    }
    
    struct Output {
        let cityList: Observable<[CityDetail]> = Observable([])
        let didSelectRowAt: Observable<Void?> = Observable(nil)
        let weatherList: Observable<[Weather]> = Observable([])
        let searchButtonClicked: Observable<Void?> = Observable(nil)
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
        
        input.didSelectRowAt.lazyBind { [weak self] id in
            guard let idValue = id else { return }
            self?.saveId(idValue: idValue)
            self?.output.didSelectRowAt.value = ()
        }
        
        input.searchTextDidChange.lazyBind { [weak self] text in
            guard let text = text else { return }
            self?.searchCity(text: text)
        }
        
        input.searchButtonClicked.lazyBind { [weak self] text in
            guard let text = text else { return }
            self?.searchCity(text: text)
            self?.output.searchButtonClicked.value = ()
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
                
                for i in 0..<5 {
                    if i == 0 {
                        for j in 0..<20 {
                            cityIdList.append("\(output.cityList.value[j].id)")
                        }
                        
                        idListString = cityIdList.joined(separator: ",")
                        
                        callGroupWeatherAPI(id: idListString)
                        cityIdList = []
                    } else if i == 4 {
                        for j in i * 20..<city.cities.count {
                            cityIdList.append("\(output.cityList.value[j].id)")
                        }
                        
                        idListString = cityIdList.joined(separator: ",")
                        
                        callGroupWeatherAPI(id: idListString)
                        cityIdList = []
                    } else {
                        for j in i * 20..<i * 20 + 20 {
                            cityIdList.append("\(output.cityList.value[j].id)")
                        }
                        
                        idListString = cityIdList.joined(separator: ",")
                        
                        callGroupWeatherAPI(id: idListString)
                        cityIdList = []
                    }
                }
            } else {
                print("데이터 파싱 실패")
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    private func callGroupWeatherAPI(id: String) {
        NetworkManager.shared.callRequest(api: .groupSearch(id: id), type: GroupWeather.self) { [weak self] response in
            switch response {
            case .success(let value):
                dump(value)
                self?.output.weatherList.value.append(contentsOf: value.list)
            case .failure(let error):
                // TODO: Alert 띄우기
                print(error)
            }
        }
    }
    
    private func saveId(idValue: Int) {
        UserDefaultsManager.cityId = idValue
    }
    
    private func searchCity(text: String) {
        print(text)
    }
}
