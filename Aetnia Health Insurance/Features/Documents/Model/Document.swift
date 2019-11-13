//
//  Document.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import PDFKit


struct Document: Hashable, Identifiable {
    var id: String
    var owner: UUID
    var pdf: PDFDocument
    var title: String
    var shortTitle: String?
    var date: Date
}
