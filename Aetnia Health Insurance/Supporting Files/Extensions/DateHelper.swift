//
//  DateHelper.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

extension Date {
    
    func hasSame(_ components: Set<Calendar.Component>, as date: Date, using calendar: Calendar = .autoupdatingCurrent) -> Bool {
        return components.filter { calendar.component($0, from: date) != calendar.component($0, from: self) }.isEmpty
    }
    
}
