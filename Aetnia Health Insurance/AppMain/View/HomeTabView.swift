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
    @EnvironmentObject var doctorSearchViewModel: DoctorSearchViewModel
    @State private var selection = 0
    @State private var first = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
                .foregroundColor(Color(.appColor(.navBarColor)))
                .edgesIgnoringSafeArea(.all)
            TabView(selection: self.$selection){
                NavigationView {
                    HomeView(model: UserInfoViewModel(model: UserViewModel(user: userAuth.loggedInUser))).modifier(AetniaNavConfig(navTitle: "Aetnia"))
                    }.navigationViewStyle(StackNavigationViewStyle()).accentColor(Color(UIColor.systemBackground))
                .tabItem {
                    Image(self.selection == 0 ? .homeFilled : .home)
                    Text("Home")
                
                }.tag(0)
                
                Text("Documents")
                    .tabItem {
                        Image(self.selection == 1 ? .documentsFilled : .documents)
                            .resizable()
                        
                        Text("Documents")
                }
                
                .tag(1)
                NavigationView {
                    DoctorSearchView(viewModel: self.doctorSearchViewModel).modifier(AetniaNavConfig(navTitle: "Aetnia"))
                }//.navigationViewStyle(StackNavigationViewStyle()).accentColor(Color(UIColor.systemBackground))
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
            }
                .accentColor(.appColor(.aetniaBlue))
            
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
