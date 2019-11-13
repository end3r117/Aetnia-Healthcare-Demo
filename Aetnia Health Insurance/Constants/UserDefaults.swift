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
    case rememberUserName, stayLoggedIn, savedUsername, savedUser
}

var versionNumber: String = "DEMO_0.9.0"
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
    
    @UserDefault(.stayLoggedIn, defaultValue: false)
    var stayLoggedIn: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault(.rememberUserName, defaultValue: false)
    var rememberUsername: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(.savedUsername, defaultValue: "")
    var savedUsername: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    var savedUser: User? {
        get {
            do {
                
                if let data = UserDefaults.standard.object(forKey: AHIUserDefaultKeys.savedUser.rawValue) {
                    let user = try JSONDecoder().decode(User.self, from: data as! Data)
                    return user
                }
                return nil
            }catch let error {
                if let err = error as? DecodingError {
                    print("Error: \(err.errorDescription)\nFailure Reason: \(err.failureReason)")
                }else {
                    print("Error: \(error)")
                }
                return nil
            }
        }
        set {
            saveValue(.savedUser, value: newValue)
        }
    }
    
    func saveValue<T: Encodable>(_ key: AHIUserDefaultKeys, value: T) {
        do {
            print("Hi")
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
        catch {
            print("Failed to encode \(key.rawValue)")
        }
    }
    
}
