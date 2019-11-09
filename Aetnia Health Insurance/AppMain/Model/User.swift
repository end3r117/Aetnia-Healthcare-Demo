//
//  User.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct User {
    var username: String
    var firstName: String
    var lastName: String
    var address: Address
    var phoneNumber: PhoneNumber
    //var coverageInfo: CoverageInfo<PhysicianModel, DentistModel> <-- from failed protocol days
    var coverageInfo: CoverageInfo
    var avatar: Avatar
    private var _appointments = [Appointment]()
    var appointments: [Appointment] {
        get {
            return _appointments
        }
        set {
            self._appointments = newValue.sorted(by: { $0.date < $1.date })
        }
    }
    
    init(username: String, coverageInfo: CoverageInfo, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber, avatar: Avatar) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.phoneNumber = phoneNumber
        self.coverageInfo = coverageInfo
        self.avatar = avatar
        
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


