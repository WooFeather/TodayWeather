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
    
    struct Input {
        let searchBarButtonItemTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        let searchBarButtonItemTapped: Observable<Void> = Observable(())
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
        input.searchBarButtonItemTapped.bind { [weak self] _ in
            self?.output.searchBarButtonItemTapped.value = ()
        }
    }
}
