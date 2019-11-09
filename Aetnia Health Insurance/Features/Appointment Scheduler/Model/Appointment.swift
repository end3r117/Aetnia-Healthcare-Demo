//
//  Appointment.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

protocol DoctorService {}

enum PhysicianServices: String, CaseIterable, DoctorService {
    
    func getDescriptionForService() -> String {
        switch self {
        case .chronicPain:
            return "Pain mgmt. appt."
        case .physicalExam:
            return "Physical exam"
        case .looseToe:
            return "Loose toe consult"
        }
    }

    case chronicPain = "Chronic pain management"
    case physicalExam = "Physical exam"
    case looseToe = "Loose toe"
}

enum DentalServices: String, CaseIterable, DoctorService {
    func getDescriptionForService() -> String {
        switch self {
        case .rootCanal:
            return "Root canal"
        case .cleaning:
            return "Teeth cleaning"
        case .bracesNew:
            return "New braces consult"
        case .bracesCheckUp:
            return "Braces appointment"
        }
    }
    
    case rootCanal = "Root canal"
    case cleaning = "Teeth cleaning"
    case bracesNew = "Braces (new set)"
    case bracesCheckUp =  "Braces (check-up)"
}

struct Appointment: Identifiable, Hashable {
    static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    var date: Date
    var doctor: Doctor
    var service: DoctorService
}
