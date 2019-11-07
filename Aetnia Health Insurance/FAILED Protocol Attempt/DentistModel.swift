//
//  DentistModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

struct DentistModel: Dentist {    
    var id = UUID()
    var firstName: String
    var lastName: String
    var address: Address
    var phoneNumber: PhoneNumber
    var acceptsHMO: Bool

    init(acceptsHMO: Bool, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber) {
        self.acceptsHMO = acceptsHMO
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.phoneNumber = phoneNumber
    }
}
