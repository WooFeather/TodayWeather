//
//  OpenWeatherRequest.swift
//  TodayWeather
//
//  Created by 조우현 on 2/16/25.
//

import Foundation

enum OpenWeatherRequest {
    case groupSearch(id: String)
    
    private var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endpoint: URL {
        switch self {
        case .groupSearch(let id):
            return URL(string: baseURL + "group?id=\(id),&appid=\(APIKey.openWeatherAPIKey)")!
        }
    }
}
