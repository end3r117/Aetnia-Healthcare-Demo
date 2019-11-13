//
//  DoctorSearchViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class DoctorSearchViewModel: ObservableObject {
    @Published var dataSource = [Doctor]() {
           didSet {
               didChange.send(self)
           }
           
           willSet {
               willChange.send(self)
           }
       }
    func filtered(query: Binding<String>, includeDoctors: Binding<Bool>, includeDentists: Binding<Bool>) -> [Doctor] {
        
        let ds = dataSource.sorted(by: {$0.firstName.lowercased() < $1.firstName.lowercased()}).filter({ model in
            if query.wrappedValue != "" {
                return model.firstName.lowercased().contains(query.wrappedValue.lowercased()) || model.lastName.lowercased().contains(query.wrappedValue.lowercased()) || model.address.city.lowercased().contains(query.wrappedValue.lowercased())
            }
            return true
        }).filter({model in
            if includeDoctors.wrappedValue && includeDentists.wrappedValue {
                return true
            }else if includeDoctors.wrappedValue && !includeDentists.wrappedValue {
                return model.doctorType == .physician
            }else if !includeDoctors.wrappedValue && includeDentists.wrappedValue {
                return model.doctorType == .dentist
            }else {
                return false
            }
        })
        return ds
    }
    
    let didChange = PassthroughSubject<DoctorSearchViewModel,Never>()
    let willChange = PassthroughSubject<DoctorSearchViewModel,Never>()
    
    init() {
        let _ = DoctorsGenerator.populateDoctors { docs in
            if self.dataSource.isEmpty {
                self.dataSource = docs
            }
        }
    }
}
