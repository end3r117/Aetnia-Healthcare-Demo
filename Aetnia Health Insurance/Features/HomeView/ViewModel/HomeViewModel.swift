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
    var userLastName: String { get { return userViewModel.lastName } }
    var userMemberID: String { get { return userViewModel.memberID } }
    var userGroupID: String { get { return userViewModel.groupID } }
    var userAvatarView: AvatarView {
        get {
            if let avatar = userViewModel.avatar {
                return AvatarView(avatar: avatar)
            }else {
                return AvatarView(gender: .female, radius: 100)
            }
        }
    }
    
    init(loggedInUser: UserModel) {
        self.loggedInUser = loggedInUser
    }
    
}
