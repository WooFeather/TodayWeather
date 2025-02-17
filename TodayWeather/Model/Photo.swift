//
//  Photo.swift
//  TodayWeather
//
//  Created by 조우현 on 2/18/25.
//

import Foundation

struct Photo: Decodable {
    let results: [PhotoDetail]
}

struct PhotoDetail: Decodable {
    let urls: PhotoUrl
}

struct PhotoUrl: Decodable {
    let thumb: String
}
