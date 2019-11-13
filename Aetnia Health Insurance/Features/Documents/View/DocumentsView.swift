//
//  DocumentsView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct DocumentsView: View {
    var model: DocumentsViewModel
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
                .foregroundColor(Color(UIColor.systemGroupedBackground))
            List {
                Section(header: Text("Test Results")) {
                    ForEach(model.documentRows) {
                        $0
                    }
                }
                
            }.listStyle(GroupedListStyle())
            .modifier(AetniaNavConfig(navTitle: "Aetnia"))
            .background(AetniaBackground())
                .navigationBarTitle(Text("Documents"), displayMode: .inline)
        }
    }
}
