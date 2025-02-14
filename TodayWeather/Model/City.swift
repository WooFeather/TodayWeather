//
//  City.swift
//  TodayWeather
//
//  Created by 조우현 on 2/14/25.
//

import Foundation

struct City: Decodable {
    let cities: [CityDetail]
}

struct CityDetail: Decodable {
    let city: String
    let ko_city_name: String
    let country: String
    let ko_country_name: String
    let id: Int
}
