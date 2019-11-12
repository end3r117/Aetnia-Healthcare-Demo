//
//  UserGenerator.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

enum UserGenerator {
    static func getFakeUser(username: String) -> User {
        
        let doctor = PhysicianModel(acceptsHMO: true, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .male, diameter: 60), firstName: "Stephen", lastName: "Reed", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), officePhoto: .office1)
        let dentist = DentistModel(acceptsHMO: false, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .female, diameter: 60), firstName: "Catherine", lastName: "Molnar", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), officePhoto: .office6)
         let coverage = CoverageInfo(PCPInsuranceType: .HMO, dentistInsuranceType: .PPO, primaryCarePhysician: doctor, primaryDentist: dentist, memberID: "82-4987529-155", groupNumber: "297831-A")
         
         let mf = Gender(rawValue: Int.random(in: 0...1))
         switch mf {
         case .female:
             return User(username: username, coverageInfo: coverage, firstName: "Jessica", lastName: "Miller", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .female))
         default:
             return User(username: username, coverageInfo: coverage, firstName: "Nicholas", lastName: "Miller", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .male))
         }
    
     }
    
}
