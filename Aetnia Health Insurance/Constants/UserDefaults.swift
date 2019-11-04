//
//  UserDefaults.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import Combine

enum AHIUserDefaultKeys: String {
    case rememberUserName, stayLoggedIn, savedUsername
}

var versionNumber: String = "DEMO_0.9.0"
var stayLoggedIn: Bool = false
var onlineMode: Bool = false

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: AHIUserDefaultKeys, defaultValue: T) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserDefaultsSwiftUI: ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault(.rememberUserName, defaultValue: false)
    var rememberUsername: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(.savedUsername, defaultValue: nil)
    var savedUsername: String? {
        willSet {
            objectWillChange.send()
        }
    }
}
