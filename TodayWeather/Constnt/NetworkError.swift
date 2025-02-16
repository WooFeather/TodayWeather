//
//  NetworkError.swift
//  TodayWeather
//
//  Created by 조우현 on 2/17/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transportError
    case serverError(code: Int)
    case missingData
    case decodingError
}
