//
//  UserViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

struct UserViewModel {
    var user: UserModel
    
    var firstName: String { get { user.firstName }}
    var lastName: String { get { user.lastName }}
    var address: String {
        get {
            return "\(user.address.number) \(user.address.street)\n\(user.address.city), \(user.address.state) \(user.address.zip)\n\(user.address.country)"
        }
    }
    var phoneNumber: String {
        get {
            return "+\(user.phoneNumber.countryCode) (\(user.phoneNumber.areaCode))\(user.phoneNumber.number.digits.prefix(3))-\(user.phoneNumber.number.digits[3...user.phoneNumber.number.digits.endIndex])"
        }
    }
    
    
    
}
