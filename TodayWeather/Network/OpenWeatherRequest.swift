//
//  OpenWeatherRequest.swift
//  TodayWeather
//
//  Created by 조우현 on 2/16/25.
//

import Foundation

enum APIRequest {
    case groupSearch(id: String)
    case searchPhoto(query: String)
    
    private var OpenWeatherBaseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    private var UnsplashBaseURL: String {
        return "https://api.unsplash.com/search/"
    }
    
    var endpoint: URL {
        switch self {
        case .groupSearch(let id):
            return URL(string: OpenWeatherBaseURL + "group?id=\(id)&units=metric&appid=\(APIKey.openWeatherAPIKey)")!
        case .searchPhoto(let query):
            return URL(string: UnsplashBaseURL + "photos?query=\(query)&page=1&per_page=1&client_id=\(APIKey.unsplashAPIKey)")!
        }
    }
}
