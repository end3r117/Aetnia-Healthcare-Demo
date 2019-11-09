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
