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
    @State var activityItems: [Any] = []
    @State var showActivity = false
    var body: some View {
        NavigationLink(destination:
            VStack {
                PDFViewer(document: document.pdf)
            }.navigationBarTitle(Text("\(document.shortTitle ?? "Aetnia")").font(.system(size: 14, weight: .medium)))
            .navigationBarItems(trailing:
                Button(action: {
                    var tempDir: URL?
                   if self.document.pdf.documentURL == nil {
                     tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.document.title)
                        try? self.document.pdf.dataRepresentation()?.write(to: tempDir!)
                    }
                    self.activityItems = [self.document.pdf.documentURL ?? tempDir]
                    print(self.activityItems)
                    self.showActivity.toggle()
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                        .offset(x: 0, y: -4)
                            .font(Font.system(.title).weight(.light))
                            .foregroundColor(Color(.white))
                }).sheet(isPresented: self.$showActivity, content: {
                    ActivityViewController(activityItems: self.activityItems)
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

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}


