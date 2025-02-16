//
//  Date+.swift
//  TodayWeather
//
//  Created by 조우현 on 2/17/25.
//

import Foundation

extension Date {
    func toStringUTC(_ timezone: Int, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
