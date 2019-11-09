//
//  UserAuth.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/4/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Combine

class UserAuth: ObservableObject {
    var loggedInUser: User!
    
    @Published var isLoggedIn = false {
        didSet {
            didChange.send(self)
        }
        
        willSet {
            willChange.send(self)
        }
        
    }
    
    let didChange = PassthroughSubject<UserAuth,Never>()
    let willChange = PassthroughSubject<UserAuth,Never>()
    
    func login(username: String, password: String) {
        if username != "" && password != "" {
            self.loggedInUser = UserGenerator.getFakeUser(username: username)
            self.isLoggedIn = true
        }else {
            self.isLoggedIn = false
        }
    }
    
    func logout() {
        self.isLoggedIn = false
    }
    
}
