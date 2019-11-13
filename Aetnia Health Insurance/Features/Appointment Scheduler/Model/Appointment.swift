//
//  Appointment.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

protocol DoctorService: Codable {
    func getDescriptionForService() -> String
}

enum PhysicianServices: String, CaseIterable, DoctorService, Codable {
    
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

enum DentalServices: String, CaseIterable, DoctorService, Codable {
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

struct Appointment: Identifiable, Hashable, Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, date, doctor, service
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(doctor, forKey: .doctor)
        
        if doctor.doctorType == .physician {
            try container.encode((service as! PhysicianServices), forKey: .service)
        }else {
            try container.encode((service as! DentalServices), forKey: .service)
        }
    }
    
    init(date: Date, doctor: Doctor, service: DoctorService) {
        self.date = date
        self.doctor = doctor
        self.service = service
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try values.decode(UUID.self, forKey: .id)
        let date = try values.decode(Date.self, forKey: .date)
        let doctor = try values.decode(Doctor.self, forKey: .doctor)
        
        self.id = id
        self.date = date
        self.doctor = doctor
        
        
        if doctor.doctorType == .physician {
            self.service = try values.decode(PhysicianServices.self, forKey: .service)
        }else  {
            self.service = try values.decode(DentalServices.self, forKey: .service)
        }
        
    }
}
