//
//  User.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import PDFKit
import CoreData

class User: Codable, ObservableObject, Identifiable {
    
    var id = UUID()
    var username: String
    var firstName: String
    var lastName: String
    var address: Address
    var phoneNumber: PhoneNumber
    var coverageInfo: CoverageInfo
    @Published var avatar: Avatar
    private var _appointments = [Appointment]()
    var appointments: [Appointment] {
        get {
            return _appointments
        }
        set {
            self._appointments = newValue.sorted(by: { $0.date < $1.date })
        }
    }
    var documents = Set<Document>()
    
    init(username: String, coverageInfo: CoverageInfo, firstName: String, lastName: String, address: Address, phoneNumber: PhoneNumber, avatar: Avatar, documents: [Document]) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.phoneNumber = phoneNumber
        self.coverageInfo = coverageInfo
        self.avatar = avatar
        
        documents.forEach({self.documents.insert($0)})
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id, username, firstName, lastName, address, phoneNumber, coverageInfo, avatar, appointments
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(address, forKey: .address)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(coverageInfo, forKey: .coverageInfo)
        try container.encode(appointments, forKey: .appointments)
        
        
        let contextContainer = getAppDelegateCoreDataContext()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        documents.forEach({ document in
            
            guard let entity = NSEntityDescription.entity(forEntityName: "DocumentEntity", in: contextContainer) else { return }
            let doc = NSManagedObject(entity: entity, insertInto: contextContainer)
            
            
            doc.setValuesForKeys([
                "id" : id.uuidString,
                "owner" : id,
                "pdf" : document.pdf.dataRepresentation(),
                "date" : document.date,
                "title" : document.title,
                "shortTitle" : document.shortTitle ?? ""
            ])
            
            contextContainer.insert(doc)
            
        })
        
        delegate.saveContext()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        address = try values.decode(Address.self, forKey: .address)
        phoneNumber = try values.decode(PhoneNumber.self, forKey: .phoneNumber)
        avatar = try values.decode(Avatar.self, forKey: .avatar)
        coverageInfo =  try values.decode(CoverageInfo.self, forKey: .coverageInfo)
        appointments = try values.decode([Appointment].self, forKey: .appointments)
        
        let contextContainer = getAppDelegateCoreDataContext()
        let request = NSFetchRequest<NSManagedObject>(entityName: "DocumentEntity")
        var docs = try contextContainer.fetch(request)
        docs = docs.filter { (doc) -> Bool in
            guard let doc = doc as? DocumentEntity else { return false }
            doc.id = self.id.uuidString
            return doc.owner == self.id
        }
        docs.forEach({ entity in
            guard let entity = entity as? DocumentEntity else { return }
            let doc = Document(id: id.uuidString,owner: entity.owner!, pdf: PDFDocument(data: entity.pdf!)!, title: entity.title!, shortTitle: entity.shortTitle, date: entity.date!)
            documents.insert(doc)
            
        })
    }
}

struct Address: Codable {
    var street: String
    var apt: String
    var city: String
    var state: String
    var zip: String
    var country: String
}

struct PhoneNumber: Codable {
    var countryCode: Int
    var areaCode: Int
    var number: Int
}


