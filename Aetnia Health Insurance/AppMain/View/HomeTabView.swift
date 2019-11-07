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
        VStack {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    Rectangle()
                    .fill(Color.aetniaBlue)
                    .edgesIgnoringSafeArea([.leading, .trailing, .top])
                    .frame(minWidth: geo.size.width, idealWidth: geo.size.width, maxWidth: .infinity, minHeight: 20, idealHeight: 44, maxHeight: 48)
                    Text("Aetnia")
                        .font(.custom("Arial-BoldItalicMT", size: 28))
                        .foregroundColor(.white)
                    HStack(alignment: .top) {
                        Spacer()
                        Button(action: {
                            self.userAuth.logout()
                        }, label: {
                            Image(.logoutButton)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 36)
                                .accentColor(.white)
                        }).padding(.trailing, 16)
                    }
                        
                }
            //NavigationView {
                TabView(selection: self.$selection){
                
                    HomeView(homeViewModel: HomeViewModel(loggedInUser: self.userAuth.loggedInUser))
                    .animation(nil)
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
                }.padding(.top, (geo.size.width > geo.size.height ? 0 : 44 ))
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
            }
        }
        .modifier(AetniaBackgroundViewModifier())
    }
}
