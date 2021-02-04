//
//  UserDefaultsPersistance.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 03.02.2021.
//

import Foundation

class UserDefaultsPersistance {
    static let shared = UserDefaultsPersistance()
    
    private let kFirstNameKey = "UserDefaultsPersistance.kFirstNameKey"
    private let kSecondNameKey = "UserDefaultsPersistance.kSecondNameKey"
    
    private let kDailyKey = "UserDefaultsPersistance.kDailyKey"
    private let kForecastKey = "UserDefaultsPersistance.kForecastKey"

    var firstName: String? {
        get { UserDefaults.standard.string(forKey: kFirstNameKey) }
        set { UserDefaults.standard.set(newValue, forKey: kFirstNameKey) }
    }

    var secondName: String? {
        get { UserDefaults.standard.string(forKey: kSecondNameKey) }
        set { UserDefaults.standard.set(newValue, forKey: kSecondNameKey) }
    }

    var daily: NSDictionary? {
        get { UserDefaults.standard.dictionary(forKey: kDailyKey) as NSDictionary? }
        set { UserDefaults.standard.set(newValue, forKey: kDailyKey) }
    }
    
    var forecast: NSDictionary? {
        get { UserDefaults.standard.dictionary(forKey: kForecastKey) as NSDictionary? }
        set { UserDefaults.standard.set(newValue, forKey: kForecastKey) }
    }
}
