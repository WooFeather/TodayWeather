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
        
    }
    
    struct Output {
        
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
        
    }
}
