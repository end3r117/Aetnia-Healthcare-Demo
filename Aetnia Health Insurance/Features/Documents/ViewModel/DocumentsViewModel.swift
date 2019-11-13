//
//  DocumentsViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import PDFKit

struct DocumentsViewModel {
    private var documents = Set<Document>()
    
    var documentRows: [DocumentsRow] {
        get {
            var docs = [DocumentsRow]()
            documents.forEach({doc in
                docs.append(DocumentsRow(document: doc))
            })
            return docs
        }
    }
    
    init(documents: [Document]) {
        documents.forEach({
            self.documents.insert($0)
        })
        
    }
    
}
