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
        input.viewDidLoadTrigger.bind { [weak self] _ in
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
            } else {
                print("데이터 파싱 실패")
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
}
