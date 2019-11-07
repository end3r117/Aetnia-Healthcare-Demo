//
//  UserGenerator.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

class UserGenerator: DoctorsGenerator {
    static func getFakeUser(username: String) -> UserModel {
        
         let doctor = PhysicianModel(acceptsHMO: true, firstName: "Nicholas", lastName: "Miller", address: getAddress()!, phoneNumber: getPhoneNumber())
         let dentist = DentistModel(acceptsHMO: false, firstName: "Jessica", lastName: "Day", address: getAddress()!, phoneNumber: getPhoneNumber())
         let coverage = CoverageInfo(PCPInsuranceType: .HMO, dentistInsuranceType: .PPO, primaryCarePhysician: doctor, primaryDentist: dentist, memberID: "82-4987529-155", groupNumber: "297831-A")
         
         let mf = Gender(rawValue: Int.random(in: 0...1))
         switch mf {
         case .female:
             return UserModel(username: username, coverageInfo: coverage, firstName: "Jennifer", lastName: "Miller", address: getAddress()!, phoneNumber: getPhoneNumber(), profilePicture: nil, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .female))
         default:
             return UserModel(username: username, coverageInfo: coverage, firstName: "Nicholas", lastName: "Miller", address: getAddress()!, phoneNumber: getPhoneNumber(), profilePicture: nil, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .male))
         }
    
     }
    
}
