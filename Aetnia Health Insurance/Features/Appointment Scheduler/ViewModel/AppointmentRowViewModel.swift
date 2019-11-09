//
//  AppointmentViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

struct AppointmentRowViewModel: Identifiable {
    var id = UUID()
    var appointment: Appointment
    
    var service: String {
        get {
            if appointment.service is PhysicianServices {
                return (appointment.service as! PhysicianServices).getDescriptionForService()
            }else {
                return (appointment.service as! DentalServices).getDescriptionForService()
            }
        }
    }
    var date: String {
        get {
            let dateFormatter = DateFormatter()
            if appointment.date.hasSame(.init(arrayLiteral: .year), as: Date()) {
                dateFormatter.dateFormat = "MMM dd"
            }else {
                dateFormatter.dateFormat = "MM/dd/yyyy"
            }
            return dateFormatter.string(from: appointment.date)
        }
    }
    var doctor: String {
        get {
            if appointment.doctor is PhysicianModel {
                return "Dr. \((appointment.doctor as! PhysicianModel).lastName)"
            }else {
                return "Dr. \((appointment.doctor as! DentistModel).lastName)"
            }
        }
    }
    
    var addressNumberStreet: String { get { "\(appointment.doctor.address.number) \(appointment.doctor.address.street)" }}
    var addressCityState: String { get { "\(appointment.doctor.address.city), \(appointment.doctor.address.state)" }}
    var addressZip: String { get { "\(appointment.doctor.address.zip)" }}
    var time: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: appointment.date)
        }
    }
    
    
}
