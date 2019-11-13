//
//  Doctor.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Combine
import SwiftUI

class Doctor: Codable {
    
    var id = UUID()
    var avatar: Avatar
    var firstName: String
    var lastName: String
    var address: Address
    var phoneNumber: PhoneNumber
    var acceptsHMO: Bool
    var officePhoto: ImageAssetName
    var doctorType: DoctorType
    
    init(doctorType: DoctorType, acceptsHMO: Bool, avatar: Avatar, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber, officePhoto: ImageAssetName) {
        self.doctorType = doctorType
        self.acceptsHMO = acceptsHMO
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.phoneNumber = phoneNumber
        self.officePhoto = officePhoto
    }
    
    enum CodingKeys: String, CodingKey {
        case id, physicianAvatar, dentistAvatar, firstName, lastName, address, phoneNumber, acceptsHMO, officePhoto, doctorType
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        doctorType = try values.decode(DoctorType.self, forKey: .doctorType)
        acceptsHMO = try values.decode(Bool.self, forKey: .acceptsHMO)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        address = try values.decode(Address.self, forKey: .address)
        phoneNumber = try values.decode(PhoneNumber.self, forKey: .phoneNumber)
        officePhoto = try values.decode(ImageAssetName.self, forKey: .officePhoto)
        if self.doctorType == .physician  {
            self.avatar = try values.decode(Avatar.self, forKey: .physicianAvatar)
        }else {
            self.avatar = try values.decode(Avatar.self, forKey: .dentistAvatar)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if self.doctorType == .physician {
            try container.encode(avatar, forKey: .physicianAvatar)
        }else {
            try container.encode(avatar, forKey: .dentistAvatar)
        }
        
        try container.encode(doctorType, forKey: .doctorType)
        try container.encode(acceptsHMO, forKey: .acceptsHMO)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(address, forKey: .address)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(officePhoto, forKey: .officePhoto)
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

enum DoctorType: String, Codable {
    case physician = "M.D."
    case dentist = "D.D.S."
}
