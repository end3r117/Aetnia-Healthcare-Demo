//
//  PDFView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    typealias UIViewType = PDFView
    
    var document: PDFDocument
    
    func makeUIView(context: UIViewRepresentableContext<PDFViewer>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.scaleFactor = 0.85
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFViewer>) {
        
    }
    
    
}
