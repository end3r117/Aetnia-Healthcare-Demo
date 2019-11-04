//
//  DoctorProtocol.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

protocol Doctor: Identifiable, Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
    
    var id: UUID { get }
    var firstName: String { get set }
    var lastName: String { get set }
    var address: Address { get set }
    var phoneNumber: PhoneNumber { get set }
    var acceptsHMO: Bool { get set }

    init(acceptsHMO: Bool, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber)
}

extension Doctor {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
}

protocol Dentist: Doctor {
    
}

enum InsuranceType {
    case HMO, PPO
}

struct CoverageInfo<T: Doctor, U: Dentist> {
    var PCPInsuranceType: InsuranceType
    var dentistInsuranceType: InsuranceType
    var primaryCarePhysician: T
    var primaryDentist: U
}

