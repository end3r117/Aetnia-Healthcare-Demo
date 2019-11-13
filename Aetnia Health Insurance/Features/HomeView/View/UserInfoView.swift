//
//  UserInfoView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct UserInfoView: View {
    @State var model: UserInfoViewModel
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var animation: Animation {
        Animation.easeIn(duration: 0.3)
        
    }
    @State var shouldRotate: Bool = false
    @State var avatarView: AvatarView? = nil
    @State var rotation: Double = 0
    @State var avatarEdited = false
    
    var body: some View {
        switch sizeClass {
        case .compact:
            return AnyView(
                GeometryReader { geo in
                    VStack {
                        HStack {
                            if self.avatarEdited {
                            Spacer()
                            }
                            VStack {
                                Button(action: {
                                    DispatchQueue.main.async {
                                        withAnimation(self.animation) {
                                            self.avatarEdited = true
                                            self.avatarView = self.model.refreshAvatar(150)
                                            withAnimation(self.animation) {
                                                self.rotation += 360
                                            }
                                        }
                                    }
                                }, label: {
                                    self.avatarView ?? self.model.getUserAvatarView(150)
                                })
                                    .rotation3DEffect(Angle(degrees: self.rotation), axis: (x: 0, y: 45, z: 0))
                            }
                            if self.avatarEdited {
                            VStack {
                                Button(action: {
                                    DispatchQueue.main.async {
                                        self.model.changeAvatar(.save, avatarView: self.avatarView)
                                        withAnimation {
                                        self.avatarEdited = false
                                        //self.mode.wrappedValue.dismiss()
                                        }
                                    }
                                }){
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .circular)
                                            .fill()
                                            .foregroundColor(Color(.systemGreen))
                                        Text("Save")
                                            .foregroundColor(Color(.label))
                                    }
                                }.frame(maxWidth: 160, maxHeight: 45)
                                Button(action: {
                                    DispatchQueue.main.async {
                                        self.model.changeAvatar(.revert)
                                        self.avatarView = self.model.getUserAvatarView(150)
                                        self.avatarEdited = false
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .circular)
                                            .fill()
                                            .foregroundColor(Color(.aetniaGrey))
                                        Text("Revert")
                                            .foregroundColor(Color(.label))
                                    }
                                }.frame(maxWidth: 160, maxHeight: 45)
                                }
                            Spacer()
                            }
                        }.padding()
                            .background(
                                Rectangle()
                                    .fill()
                                    .foregroundColor(Color(UIColor.systemBackground))
                        )
                        
                        List {
                            Section(header: Text("First Name"), content: {
                                TextField("Jim", text: self.$model.firstName)
                            })
                            Section(header: Text("Last Name"), content: {
                                TextField("Halpert", text: self.$model.lastName)
                            })
                            Section(header: Text("Address (Street)"), content: {
                                TextField("123 Main St.", text: self.$model.addressStreet)
                            })
                            Section(header: Text("Apt"), content: {
                                TextField("Apartment, Unit, etc.", text: self.$model.addressApt)
                            })
                            Section(header: Text("Address (City)"), content: {
                                TextField("Middletown", text: self.$model.addressCity)
                            })
                            Section(header: Text("Address (State)"), content: {
                                TextField("California", text: self.$model.addressState)
                            })
                            Section(header: Text("Address (Zip)"), content: {
                                TextField("Zip Code", text: self.$model.addressZip)
                            })
                        }.listStyle(GroupedListStyle())
                            .accentColor(Color(.white))
                            .dismissKeyboardOnDragGesture()
                    }.dismissKeyboardOnTapGesture()
                        .background(AetniaBackground())
                        .navigationBarItems(leading:
                            Button(action: {
                                self.mode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color(.systemBackground))
                                Text("Home")
                                    .foregroundColor(Color(.systemBackground))
                            })
                    )
                }
            )
        default:
            return AnyView(
                GeometryReader { geo in
                    HStack {
                        HStack {
                            Spacer()
                            VStack {
                                Button(action: {
                                    DispatchQueue.main.async {
                                        withAnimation(self.animation) {
                                            self.avatarView = self.model.refreshAvatar(150)
                                            withAnimation(self.animation) {
                                                self.rotation += 360
                                            }
                                        }
                                    }
                                }, label: {
                                    self.avatarView ?? self.model.getUserAvatarView(150)
                                })
                                    .rotation3DEffect(Angle(degrees: self.rotation), axis: (x: 0, y: 45, z: 0))
                            }
                            VStack {
                                Button(action: {
                                    DispatchQueue.main.async {
                                        self.model.changeAvatar(.save, avatarView: self.avatarView)
                                        self.mode.wrappedValue.dismiss()
                                    }
                                }){
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .circular)
                                            .fill()
                                            .foregroundColor(Color(.systemGreen))
                                        Text("Save")
                                            .foregroundColor(Color(.label))
                                    }
                                }.frame(maxWidth: 160, maxHeight: 45)
                                Button(action: {
                                    DispatchQueue.main.async {
                                        self.model.changeAvatar(.revert)
                                        self.avatarView = self.model.getUserAvatarView(150)
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .circular)
                                            .fill()
                                            .foregroundColor(Color(.aetniaGrey))
                                        Text("Revert")
                                            .foregroundColor(Color(.label))
                                    }
                                }.frame(maxWidth: 160, maxHeight: 45)
                            }
                            Spacer()
                        }.padding()
                        List {
                            Section(header: Text("First Name"), content: {
                                TextField("Jim", text: self.$model.firstName)
                            })
                            Section(header: Text("Last Name"), content: {
                                TextField("Halpert", text: self.$model.lastName)
                            })
                            Section(header: Text("Address (Street)"), content: {
                                TextField("123 Main St.", text: self.$model.addressStreet)
                            })
                            Section(header: Text("Apt"), content: {
                                TextField("Apartment, Unit, etc.", text: self.$model.addressApt)
                            })
                            Section(header: Text("Address (City)"), content: {
                                TextField("Middletown", text: self.$model.addressCity)
                            })
                            Section(header: Text("Address (State)"), content: {
                                TextField("California", text: self.$model.addressState)
                            })
                            Section(header: Text("Address (Zip)"), content: {
                                TextField("Zip Code", text: self.$model.addressZip)
                            })
                        }.listStyle(GroupedListStyle())
                            .accentColor(Color(.white))
                            .dismissKeyboardOnDragGesture()
                    }.dismissKeyboardOnTapGesture()
                        .background(AetniaBackground())
                        .navigationBarItems(leading:
                            Button(action: {
                                self.mode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color(.systemBackground))
                                Text("Home")
                                    .foregroundColor(Color(.systemBackground))
                            })
                    )
                }
            )
        }
    }
}
