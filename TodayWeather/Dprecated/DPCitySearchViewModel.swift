//
//  CitySearchViewModel.swift
//  TodayWeather
//
//  Created by 조우현 on 2/13/25.
//

import Foundation

final class DPCitySearchViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private var idListString = ""
    private var cityIdList: [String] = []
    
    struct Input {
        let viewDidLoadTrigger: DPObservable<Void?> = DPObservable(nil)
        let didSelectRowAt: DPObservable<Int?> = DPObservable(nil)
        let searchTextDidChange: DPObservable<String?> = DPObservable("")
        let searchButtonClicked: DPObservable<String?> = DPObservable("")
    }
    
    struct Output {
        let cityList: DPObservable<[CityDetail]> = DPObservable([])
        let didSelectRowAt: DPObservable<Void?> = DPObservable(nil)
        let weatherList: DPObservable<[Weather]> = DPObservable([])
        let searchButtonClicked: DPObservable<Void?> = DPObservable(nil)
        let filteredCityList: DPObservable<[CityDetail]> = DPObservable([])
        let isTableViewHidden: DPObservable<Bool> = DPObservable(false)
        let isEmptyLabelHidden: DPObservable<Bool> = DPObservable(true)
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
                output.filteredCityList.value = city.cities
                
                for i in 0..<5 {
                    if i == 0 {
                        for j in 0..<20 {
                            cityIdList.append("\(output.filteredCityList.value[j].id)")
                        }
                        
                        idListString = cityIdList.joined(separator: ",")
                        
                        callGroupWeatherAPI(id: idListString)
                        cityIdList = []
                    } else if i == 4 {
                        for j in i * 20..<city.cities.count {
                            cityIdList.append("\(output.filteredCityList.value[j].id)")
                        }
                        
                        idListString = cityIdList.joined(separator: ",")
                        
                        callGroupWeatherAPI(id: idListString)
                        cityIdList = []
                    } else {
                        for j in i * 20..<i * 20 + 20 {
                            cityIdList.append("\(output.filteredCityList.value[j].id)")
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
//        NetworkManager.shared.callRequest(api: .groupSearch(id: id), type: GroupWeather.self) { [weak self] response in
//            switch response {
//            case .success(let value):
//                dump(value)
//                self?.output.weatherList.value.append(contentsOf: value.list)
//            case .failure(let error):
//                // TODO: Alert 띄우기
//                print(error)
//            }
//        }
    }
    
    private func saveId(idValue: Int) {
        UserDefaultsManager.cityId = idValue
    }
    
    private func searchCity(text: String) {
        if text.isEmpty {
            output.isTableViewHidden.value = false
            output.isEmptyLabelHidden.value = true
            self.output.filteredCityList.value = self.output.cityList.value
        } else {
            let filteredList = self.output.cityList.value.filter {
                $0.koCityName.contains(text) || $0.koCountryName.contains(text) || $0.city.contains(text) || $0.country.contains(text)
            }
            
            if filteredList.isEmpty {
                output.isTableViewHidden.value = true
                output.isEmptyLabelHidden.value = false
                print(self.output.filteredCityList.value)
            } else {
                output.isTableViewHidden.value = false
                output.isEmptyLabelHidden.value = true
                self.output.filteredCityList.value = filteredList
                print(self.output.filteredCityList.value)
            }
        }
    }
}
