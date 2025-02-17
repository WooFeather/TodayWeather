//
//  UserDefaultsManager.swift
//  TodayWeather
//
//  Created by 조우현 on 2/18/25.
//

import Foundation

@propertyWrapper
struct MyUserDefaults<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case cityId
    }
    
    @MyUserDefaults(key: Key.cityId.rawValue, defaultValue: 1835848)
    static var cityId
}
