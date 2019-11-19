//
//  HomeTabView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/4/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct AppMainTabView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var selection = 0
    @State private var first = true
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
                .foregroundColor(Color(.appColor(.navBarColor)))
                .edgesIgnoringSafeArea(.all)
            if userAuth.loggedInUser != nil {
                TabView(selection: self.$selection){
                    NavigationView {
                        HomeView()
                            .modifier(AetniaNavConfig(navTitle: "Aetnia")).accentColor(.aetniaBlue)
                    }.navigationViewStyle(StackNavigationViewStyle()).accentColor(Color(UIColor.systemBackground)).environment(\.horizontalSizeClass, .compact)
                        .tabItem {
                            Image(self.selection == 0 ? .homeFilled : .home)
                            Text("Home")
                            
                    }.tag(0)
                    NavigationView {
                        DocumentsView(model: DocumentsViewModel(documents: userAuth.loggedInUser!.documents.map({$0})))
                    }.navigationViewStyle(StackNavigationViewStyle()).accentColor(Color(UIColor.systemBackground)).environment(\.horizontalSizeClass, .compact)
                        .tabItem {
                            Image(self.selection == 1 ? .documentsFilled : .documents)
                                .resizable()
                            Text("Documents")
                    }
                    .tag(1)
                    NavigationView {
                        DoctorSearchView()
                            .modifier(AetniaNavConfig(navTitle: "Doctor Search")).accentColor(.white)
                    }.navigationViewStyle(StackNavigationViewStyle()).environment(\.horizontalSizeClass, .compact) 
                        .tabItem {
                            Image(self.selection == 2 ? .docSearchFilled : .docSearch)
                                .resizable()
                            Text("Doc Search")
                    }
                    .tag(2)
                    NavigationView {
                        VStack {
                            Text("Don't mind the badge icon.")
                            .padding()
                            Text("You will never get new notifications.")
                            Text("It's nothing personal.")
                            .padding()
                            }
                        .modifier(AetniaNavConfig(navTitle: "Notifications")).accentColor(.white)
                    }
                        .tabItem {
                            Image(self.selection == 3 ? .notificationsBadgedFilled : .notificationsBadged)
                            Text("Notifications")
                    }
                    .tag(3)
                    NavigationView {
                        Text("Prescriptions")
                    }
                        .tabItem {
                            Image(self.selection == 4 ? .prescriptionsFilled : .prescriptions)
                            Text("Rx")
                    }
                    .tag(4)
                }
                .accentColor(.appColor(.aetniaBlue))
            }
        }
    }
}


/*
 .navigationBarTitle("Aetnia", displayMode: .inline)
 .navigationBarItems(trailing:
 Button(action: {
 self.userAuth.logout()
 }, label: {
 Image(.logoutButton)
 .renderingMode(.template)
 .resizable()
 .accentColor(.white)
 })
 )
 .background(AppMainNavigationBar())
 .transition(.opacity)
 .animation(.easeOut)
 //}
 */
