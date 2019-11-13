//
//  CoverageInfo.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

enum InsuranceType: String, Codable {
    case HMO, PPO
}

struct CoverageInfo: Codable {
    var PCPInsuranceType: InsuranceType
    var dentistInsuranceType: InsuranceType
    var primaryCarePhysician: Doctor
    var primaryDentist: Doctor
    var memberID: String
    var groupNumber: String
}
