//
//  Doctor.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Combine
import SwiftUI

class Doctor {
    
    var id = UUID()
    var avatar: Avatar?
    var firstName: String
    var lastName: String
    var address: Address
    var phoneNumber: PhoneNumber
    var acceptsHMO: Bool
    var officePhoto: ImageAssetName
    
    required init(acceptsHMO: Bool, avatar: Avatar?, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber, officePhoto: ImageAssetName) {
        self.acceptsHMO = acceptsHMO
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.phoneNumber = phoneNumber
        self.officePhoto = officePhoto
    }
    
    
}

extension Doctor: Identifiable, Hashable {
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
}

extension Doctor: ObservableObject {
    
}

enum DoctorType: String {
    case physician = "M.D."
    case dentist = "D.D.S."
}

class PhysicianModel: Doctor {

}

class DentistModel: Doctor {
    
}
