//
//  DocumentsRow.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import PDFKit

struct DocumentsRow: View, Identifiable {
    var id = UUID()
    var document: Document
    @EnvironmentObject var navConfig: NavConfig
    @State var showActivity = false
    var body: some View {
        NavigationLink(destination:
            VStack {
                PDFViewer(document: document.pdf)
            }.navigationBarTitle(Text("\(document.shortTitle ?? "Aetnia")").font(.system(size: 14, weight: .medium)))
            .navigationBarItems(trailing:
                Button(action: {
                    let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.document.title)
                    if self.document.pdf.documentURL == nil {
                        try? self.document.pdf.dataRepresentation()?.write(to: tempDir)
                    }
                    let vc = UIActivityViewController(activityItems: [self.document.pdf.documentURL ?? tempDir], applicationActivities: nil)
                    let nc = self.navConfig.navigationController
                    nc?.present(vc, animated: true)
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                    .offset(x: 0, y: -4)
                        .font(Font.system(.title).weight(.light))
                        .foregroundColor(Color(.white))
                    })
            )
        ) {
            VStack(alignment: .leading) {
                Text("\(document.title)").bold()
                Text(formatDate(document.date))
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date)
    }
    
}




