//
//  WeatherWords.swift
//  TodayWeather
//
//  Created by 조우현 on 2/16/25.
//

import Foundation

enum WeatherWords: String, CaseIterable {
    case Thunderstorm = "Thunderstorm"
    case Drizzle = "Drizzle"
    case Rain = "Rain"
    case Snow = "Snow"
    case Mist = "Mist"
    case Smoke = "Smoke"
    case Haze = "Haze"
    case Dust = "Dust"
    case Fog = "Fog"
    case Sand = "Sand"
    case Ash = "Ash"
    case Squall = "Squall"
    case Tornado = "Tornado"
    case Clear = "Clear"
    case Clouds = "Clouds"
    
    var koreanWord: String {
        switch self {
        case .Thunderstorm:
            return "뇌우"
        case .Drizzle:
            return "이슬비"
        case .Rain:
            return "비"
        case .Snow:
            return "눈"
        case .Mist:
            return "안개"
        case .Smoke:
            return "연기"
        case .Haze:
            return "옅은안개"
        case .Dust:
            return "먼지"
        case .Fog:
            return "짙은안개"
        case .Sand:
            return "모래먼지"
        case .Ash:
            return "화산재"
        case .Squall:
            return "스콜"
        case .Tornado:
            return "토네이도"
        case .Clear:
            return "맑음"
        case .Clouds:
            return "흐림"
        }
    }
}
