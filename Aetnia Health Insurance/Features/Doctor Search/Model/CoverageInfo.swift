//
//  CoverageInfo.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

enum InsuranceType: String {
    case HMO, PPO
}

struct CoverageInfo {
    var PCPInsuranceType: InsuranceType
    var dentistInsuranceType: InsuranceType
    var primaryCarePhysician: PhysicianModel
    var primaryDentist: DentistModel
    var memberID: String
    var groupNumber: String
}
