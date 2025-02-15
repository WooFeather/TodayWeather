//
//  City.swift
//  TodayWeather
//
//  Created by 조우현 on 2/14/25.
//

import Foundation

struct City: Codable {
    let cities: [CityDetail]
}

struct CityDetail: Codable {
    let city: String
    let koCityName: String
    let country: String
    let koCountryName: String
    let id: Int
}
