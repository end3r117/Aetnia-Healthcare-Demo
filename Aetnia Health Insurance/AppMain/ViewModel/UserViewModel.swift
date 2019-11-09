//
//  UserViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

struct UserViewModel {
    var user: User
    var avatar: Avatar { get { user.avatar } set { user.avatar = newValue }}
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
    
    var medicalInsuranceType: InsuranceType { get { user.coverageInfo.PCPInsuranceType }}
    var dentistInsuranceType: InsuranceType { get { user.coverageInfo.dentistInsuranceType }}
    var primaryCarePhysician: PhysicianModel { get { user.coverageInfo.primaryCarePhysician }}
    var primaryDentist: DentistModel { get { user.coverageInfo.primaryDentist }}
    var memberID: String { get { user.coverageInfo.memberID }}
    var groupID: String { get { user.coverageInfo.groupNumber }}
    
    //CoverageInfo(PCPInsuranceType: .HMO, dentistInsuranceType: .PPO, primaryCarePhysician: doctor, primaryDentist: dentist, memberID: "82-4987529-155", groupNumber: "297831-A")
    
    
    
}
