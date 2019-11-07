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
    @State var username: String = ""
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
    }
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    TextField("Username", text: self.$username)
                }
            }
            .onTapGesture {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                window?.endEditing(false)
            }
            .navigationBarTitle("Register new user")
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
