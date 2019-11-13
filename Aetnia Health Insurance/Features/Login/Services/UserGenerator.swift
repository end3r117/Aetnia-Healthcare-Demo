//
//  UserGenerator.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import PDFKit
import CoreData

enum UserGenerator {
    static func getFakeUser(username: String) -> User {
        
        let doctor = Doctor(doctorType: .physician,acceptsHMO: true, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .male, diameter: 60), firstName: "Stephen", lastName: "Reed", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), officePhoto: .office1)
        let dentist = Doctor(doctorType: .dentist, acceptsHMO: false, avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .female, diameter: 60), firstName: "Catherine", lastName: "Molnar", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), officePhoto: .office6)
         let coverage = CoverageInfo(PCPInsuranceType: .HMO, dentistInsuranceType: .PPO, primaryCarePhysician: doctor, primaryDentist: dentist, memberID: "82-4987529-155", groupNumber: "297831-A")
         
         let mf = Gender(rawValue: Int.random(in: 0...1))
         switch mf {
         case .female:
            let docs = [Document]()
            let user = User(username: username, coverageInfo: coverage, firstName: "Jessica", lastName: "Miller", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .female), documents: docs)
            if let url = Bundle.main.url(forResource: "CBCSample", withExtension: "pdf") {
                user.documents.insert(Document(id: user.id.uuidString, owner: user.id, pdf: PDFDocument(url: url)!, title: "Complete Blood Count", shortTitle: "CBC", date: Date(timeIntervalSinceNow: Double(Int.random(in: -50000...1000)))))
            }
            return user
         default:
            let docs = [Document]()
            let user = User(username: username, coverageInfo: coverage, firstName: "Nicholas", lastName: "Miller", address: DoctorsGenerator.getAddress()!, phoneNumber: DoctorsGenerator.getPhoneNumber(), avatar: AvatarMaker.makeMeAnAvatarPlease(gender: .male), documents: docs)
            if let url = Bundle.main.url(forResource: "CBCSample", withExtension: "pdf") {
                user.documents.insert(Document(id: user.id.uuidString, owner: user.id, pdf: PDFDocument(url: url)!, title: "Complete Blood Count", shortTitle: "CBC", date: Date(timeIntervalSinceNow: Double(Int.random(in: -50000...1000)))))
            }
            return user
         }
    
     }
    
}
