//
//  LoginView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var userDefaults: UserDefaultsSwiftUI
    
    @State var username: String = ""
    @State var password: String = ""
    @State var shouldRememberUsername: Bool = false
    @State var keepMeLoggedIn: Bool = false
    @State var showAlert: Bool = false
    @State var showRegistration: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { (geometry) in
                Image(.loginBackground)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack  {
                    Text(verbatim: "Aetnia")
                        .font(Font.custom("Arial", size: 80).italic().bold())
                        .foregroundColor(.aetniaBlue)
                        
                    HStack {
                        Spacer()
                            .frame(maxWidth: geometry.size.width / 2 + geometry.size.width * 0.02)
                        Text(verbatim: "healthcare partners")
                            .font(Font.custom("Arial", size: 20))
                            .foregroundColor(.aetniaBlue)
                        Spacer()
                    }.padding([.trailing], geometry.size.width * 0.08)
                    Spacer()
                        .frame(maxHeight: geometry.size.height * 0.15)
                    VStack(alignment: .leading) {
                        LoginTextField(text: self.$username, title: "Username", isPrivate: false, size:(UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: geometry.size.width * 0.67, height: 44) : CGSize(width: geometry.size.width * 0.33, height: 44)), roundedStyle: .roundedTop)
                            .onAppear {
                                if self.userDefaults.savedUsername != nil && self.userDefaults.rememberUsername {
                                    self.username = self.userDefaults.savedUsername ?? ""
                                    self.shouldRememberUsername = true
                                }
                        }
                            
                        LoginTextField(text: self.$password, title: "Password", isPrivate: true, size:(UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: geometry.size.width * 0.67, height: 44) : CGSize(width: geometry.size.width * 0.33, height: 44)), roundedStyle: .roundedBottom)
                            .padding(.top, 16)
                        
                        HStack(alignment: .center) {
                            BEMCheckBoxView(on: self.$shouldRememberUsername)
                                .frame(width: 20, height: 20)
                            Text("Remember me")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.5)))
                                .padding(.leading, 2)
                                .opacity(0.85)
                        }.padding(.top, 10)
                        HStack(alignment: .center) {
                            BEMCheckBoxView(on: self.$keepMeLoggedIn)
                                .frame(width: 20, height: 20)
                            Text("Keep me logged in")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.5)))
                                .padding(.leading, 2)
                                .opacity(0.85)
                        }.padding(.top, 2)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            if self.username == "" || self.password == "" {
                                self.showAlert = true
                            }else {
                                self.userDefaults.rememberUsername = self.shouldRememberUsername
                                if self.shouldRememberUsername {
                                    self.userDefaults.savedUsername = self.username
                                }else {
                                    self.userDefaults.savedUsername = nil
                                }
                                self.userAuth.login(username: self.username, password: self.password)
                            }
                        }) {
                            Text("Login")
                                .font(.system(size: 18, weight: .bold))
                                .padding()
                                .frame(width: geometry.size.width * 0.30, height: geometry.size.height * 0.05)
                                .background(Color.aetniaBlue)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .padding(3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.aetniaBlue, lineWidth: 2)
                            )
                                .alert(isPresented: self.$showAlert) {
                                    Alert(title: Text(""), message: Text("You must enter a username and password."), dismissButton: .default(Text("Got it")))
                            }
                        }
                        Spacer()
                    }.padding(.top, 30)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Trouble logging in?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.aetniaBlue)
                            .padding(.bottom, 24)
                    }
                    Button(action: {
                        self.showRegistration.toggle()
                    }) {
                        Text("Register new account")
                            .font(.system(size: geometry.size.width * 0.05, weight: .bold))
                            .kerning(0.2)
                            //.baselineOffset(10)
                            .foregroundColor(.aetniaBlue)
                            .padding(.bottom, geometry.size.height * 0.02)
                    }.sheet(isPresented: self.$showRegistration, onDismiss: {
                        print("Bye")
                    }) {
                        CreateNewUserView()
                    }
                }
                .padding(.top, geometry.size.height * 0.05)
            }
        }.onTapGesture {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.endEditing(false)
        }
    }
}

/*
 struct LoginView_Previews: PreviewProvider {
 static var previews: some View {
 LoginView()
 }
 }
 */
