//
//  ContentView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct AppMainView: View {
    @State private var selection = 0
    @State private var authenticated: Bool = false
    
    var body: some View {
        VStack {
            if authenticated {
                TabView(selection: $selection){
                    Text(verbatim: "Home")
                        .font(.title)
                        .tabItem {
                            VStack {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                    }
                    .tag(0)
                    Text(verbatim: "Notifications")
                        .font(.title)
                        .tabItem {
                            VStack {
                                Image(systemName: "envelope.badge")
                                Text("Notifications")
                            }
                    }
                    .tag(1)
                    Text(verbatim: "Logout")
                        .font(.title)
                        .tabItem {
                            VStack {
                                Image(.exitDoor)
                                Text("Logout")
                            }
                    }
                    .tag(4)
                }
            }else {
                LoginView(authenticated: $authenticated)
                    .transition(.slide)
            }
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
