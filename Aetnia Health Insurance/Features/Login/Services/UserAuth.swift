//
//  UserAuth.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/4/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import CoreData

class UserAuth: ObservableObject {
    @Published var userDefaults = UserDefaultsSwiftUI()
    lazy var savedUsername: String? = userDefaults.savedUsername
    @Published var loggedInUser: User!
    @Published var isLoggedIn = false
    
    init(){//userDefaults: UserDefaultsSwiftUI) {
        //self.userDefaults = userDefaults
        if userDefaults.savedUser != nil && userDefaults.stayLoggedIn {
            self.loggedInUser = userDefaults.savedUser
            self.isLoggedIn = true
            print("Found saved user! \(self.loggedInUser.username)")
        }
    }
    
    func login(username: String, password: String, rememberUsername: Bool, stayLoggedIn: Bool, trigger: Binding<Bool>) {
        if username != "" && password != "" {
            self.loggedInUser = UserGenerator.getFakeUser(username: username)
            self.userDefaults.stayLoggedIn = stayLoggedIn
            if stayLoggedIn {
                self.userDefaults.savedUser = self.loggedInUser
            }
            self.userDefaults.rememberUsername = rememberUsername
            if rememberUsername {
                self.userDefaults.savedUsername = username
            }else {
                self.userDefaults.savedUsername = ""
            }
            self.isLoggedIn = true
        }else {
            self.isLoggedIn = false
            trigger.wrappedValue.toggle()
        }
    }
    
    func updateUser() {
        self.userDefaults.savedUser = self.loggedInUser
    }
    
    func logout() {
        self.isLoggedIn = false
        self.userDefaults.stayLoggedIn = false
        self.userDefaults.savedUser = nil
    }
    
}
