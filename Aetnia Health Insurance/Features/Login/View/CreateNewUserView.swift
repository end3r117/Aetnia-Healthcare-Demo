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
    @ObservedObject var registrationVerifier: RegistrationVerifier = RegistrationVerifier()
    var onRegister: ((String) -> Void)
    @State var usernameClear: Bool = false
    @State var passwordClear: Bool = false
    
    init(onRegister: @escaping ((String)->Void)) {
        self.onRegister = onRegister
        UITableView.appearance().tableFooterView = UIView()
    }
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(self.registrationVerifier.usernameMessage)
                    .foregroundColor(self.registrationVerifier.usernameValid ? Color.green : Color(.aetniaBlue))
                    .font(self.registrationVerifier.usernameValid ? .subheadline : .caption)
                    .padding([.top], 4)
                    .padding(.leading, 20)
                Text(self.registrationVerifier.passwordMessage)
                    .foregroundColor(self.registrationVerifier.passwordValid ? Color.green : Color(.aetniaBlue))
                    .font(self.registrationVerifier.passwordValid ? .subheadline : .caption)
                    .padding([.bottom], 8)
                    .padding(.leading, 20)
                Form {
                    TextField("Username", text: self.$registrationVerifier.username, onEditingChanged: { start in
                        if start {
                            self.usernameClear = true
                        }else {
                            self.usernameClear = false
                        }
                        
                    }, onCommit: {
                        self.usernameClear = false
                    }).modifier(ClearButton(text: $registrationVerifier.username, visible: $usernameClear))
                    SecureField("Password", text: self.$registrationVerifier.password)
                    SecureField("Repeat password", text: self.$registrationVerifier.repeatPassword)
                }
            }
            .navigationBarTitle("Register new account")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    }),
                trailing:
                    Button(action: {
                        self.onRegister(self.registrationVerifier.username)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }.disabled(!registrationVerifier.isValid)
            )
                .dismissKeyboardOnUserInteraction()
        }
        .accentColor(.aetniaBlue)
    }
}
