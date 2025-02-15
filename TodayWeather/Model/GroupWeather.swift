//
//  Weather.swift
//  TodayWeather
//
//  Created by 조우현 on 2/16/25.
//

import Foundation

struct GroupWeather: Decodable {
    let cnt: Int
    let list: [Weather]
}

struct Weather: Decodable {
    let time: TimeDetail
    let weather: [WeatherDetail]
    let main: MainDetail
    let wind: WindDetail
    
    enum CodingKeys: String, CodingKey {
        case time = "sys" // 일출 및 일몰시간
        case weather
        case main
        case wind
    }
}

struct TimeDetail: Decodable {
    let sunrise: Int
    let sunset: Int
}

struct WeatherDetail: Decodable {
    let word: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case word = "main" // "맑음" 등의 날씨를 나타내는 단어
        case icon
    }
}

struct MainDetail: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
}

struct WindDetail:Decodable {
    let speed: Double
}
