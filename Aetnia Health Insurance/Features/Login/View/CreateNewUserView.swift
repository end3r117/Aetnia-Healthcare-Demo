//
//  CreateNewUserView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct CreateNewUserView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Text("")
                }
            }.navigationBarTitle("Register new user")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
            
            )
        }
            .accentColor(.aetniaBlue)
    }
}
