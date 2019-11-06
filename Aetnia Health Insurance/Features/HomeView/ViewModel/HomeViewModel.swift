//
//  HomeViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

struct HomeViewModel {
    private var loggedInUser: UserModel
    private var userViewModel: UserViewModel {
        get {
            UserViewModel(user: loggedInUser)
        }
    }
    
    var userFirstName: String { get { return userViewModel.firstName } }
    
    init(loggedInUser: UserModel) {
        self.loggedInUser = loggedInUser
    }
    
}
