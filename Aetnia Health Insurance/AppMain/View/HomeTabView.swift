//
//  HomeTabView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/4/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var selection = 0 {
        didSet {
            print(selection)
        }
    }
    var body: some View {
        NavigationView {
            TabView(selection: $selection){
                
                HomeView(homeViewModel: HomeViewModel(loggedInUser: userAuth.loggedInUser))
                    .tabItem {
                        Image(self.selection == 0 ? .homeFilled : .home)
                        Text("Home")
                }
                .tag(0)
                Text("Documents")
                    .tabItem {
                        Image(self.selection == 1 ? .documentsFilled : .documents)
                            .resizable()
                        
                        Text("Documents")
                }
                .tag(1)
                Text("Doctor Search")
                    .tabItem {
                        Image(self.selection == 2 ? .docSearchFilled : .docSearch)
                            .resizable()
                        Text("Doc Search")
                }
                .tag(2)
                Text("Notifications")
                    .tabItem {
                        Image(self.selection == 3 ? .notificationsBadgedFilled : .notificationsBadged)
                        Text("Notifications")
                }
                .tag(3)
                Text("Prescriptions")
                    .tabItem {
                        Image(self.selection == 4 ? .prescriptionsFilled : .prescriptions)
                        Text("Rx")
                }
                .tag(4)
            }.navigationBarTitle("Aetnia", displayMode: .inline)
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
        }
    }
}
