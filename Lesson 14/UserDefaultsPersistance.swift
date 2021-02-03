//
//  UserDefaultsPersistance.swift
//  Lesson 13
//
//  Created by Maxim Gorin on 03.02.2021.
//

import Foundation

class UserDefaultsPersistance {
    static let shared = UserDefaultsPersistance()
    
    private let kFirstNameKey = "UserDefaultsPersistance.kFirstNameKey"
    private let kSecondNameKey = "UserDefaultsPersistance.kSecondNameKey"
    
    var firstName: String? {
        get { UserDefaults.standard.string(forKey: kFirstNameKey) }
        set { UserDefaults.standard.set(newValue, forKey: kFirstNameKey) }
    }

    var secondName: String? {
        get { UserDefaults.standard.string(forKey: kSecondNameKey) }
        set { UserDefaults.standard.set(newValue, forKey: kSecondNameKey) }
    }

}
