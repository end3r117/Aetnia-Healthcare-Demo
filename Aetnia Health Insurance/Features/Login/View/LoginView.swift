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
    
    @State var username: String = ""
    @State var password: String = ""
    @State var shouldRememberUsername: Bool = false
    @State var stayLoggedIn: Bool = false
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
                    Text("Aetnia")
                        .font(Font.custom("Arial", size: 80).italic().bold())
                        .foregroundColor(Color(UIColor.appColor(.aetniaBlue)))
                    
                    HStack {
                        Spacer()
                            .frame(maxWidth: geometry.size.width / 2 + geometry.size.width * 0.02)
                        Text("healthcare partners")
                            .font(Font.custom("Arial", size: 20))
                            .foregroundColor(Color(UIColor.appColor(.aetniaBlue)))
                        Spacer()
                    }.padding([.trailing], geometry.size.width * 0.08)
                    Spacer()
                        .frame(maxHeight: geometry.size.height * 0.15)
                    VStack(alignment: .leading) {
                        LoginTextField(text: self.$username, title: "Username", isPrivate: false, size:(UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: geometry.size.width * 0.67, height: 44) : CGSize(width: geometry.size.width * 0.33, height: 44)), roundedStyle: .roundedTop)
                            .onAppear {
                                if self.userAuth.userDefaults.savedUsername != "" && self.userAuth.userDefaults.rememberUsername {
                                    self.username = self.userAuth.userDefaults.savedUsername
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
                                .foregroundColor(.aetniaGrey)
                                .padding(.leading, 2)
                                .opacity(0.85)
                        }.padding(.top, 10)
                        HStack(alignment: .center) {
                            BEMCheckBoxView(on: self.$stayLoggedIn)
                                .frame(width: 20, height: 20)
                            Text("Keep me logged in")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.aetniaGrey)
                                .padding(.leading, 2)
                                .opacity(0.85)
                        }.padding(.top, 2)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.userAuth.login(username: self.username, password: self.password, rememberUsername: self.shouldRememberUsername, stayLoggedIn: self.stayLoggedIn, trigger: self.$showAlert)
                        }) {
                            Text("Login")
                                .font(.system(size: 18, weight: .bold))
                                .padding()
                                .frame(width: geometry.size.width * 0.30, height: geometry.size.height * 0.05)
                                .background(Color(UIColor.appColor(.aetniaBlue)))
                                .cornerRadius(8)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .padding(3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(UIColor.appColor(.aetniaBlue)), lineWidth: 2)
                            )
                        }
                        Spacer()
                    }.padding(.top, 30)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Trouble logging in?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(UIColor.appColor(.aetniaBlue)))
                            .padding(.bottom, 24)
                    }
                    Button(action: {
                        self.showRegistration.toggle()
                    }) {
                        Text("Register new account")
                            .font(.system(size: geometry.size.width * 0.05, weight: .bold))
                            .kerning(0.2)
                            .foregroundColor(Color(UIColor.appColor(.aetniaBlue)))
                            .padding(.bottom, geometry.size.height * 0.02)
                    }.sheet(isPresented: self.$showRegistration){
                        CreateNewUserView { name in
                            self.username = name
                        }
                    }
                }
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text(""), message: Text("You must enter a username and password."), dismissButton: Alert.Button.default(Text("Got it")))
                }
                .navigationBarHidden(true)
                .padding(.top, geometry.size.height * 0.05)
            }
        }
        .dismissKeyboardOnTapGesture()
    }
}
