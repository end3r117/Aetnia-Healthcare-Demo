//
//  User.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct UserModel {
    var username: String
    var firstName: String
    var lastName: String
    var address: Address
    var phoneNumber: PhoneNumber
    var coverageInfo: CoverageInfo<PhysicianModel, DentistModel>
    var profilePicture: Image?
    
    init(username: String, coverageInfo: CoverageInfo<PhysicianModel, DentistModel>, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.phoneNumber = phoneNumber
        self.coverageInfo = coverageInfo
    }
}

struct Address {
    var number: String
    var street: String
    var apt: String?
    var city: String
    var state: String
    var zip: String
    var country: String
}

struct PhoneNumber {
    var countryCode: Int
    var areaCode: Int
    var number: Int
}


