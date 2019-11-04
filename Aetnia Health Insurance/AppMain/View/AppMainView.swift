//
//  ContentView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct AppMainView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var userDefaults: UserDefaultsSwiftUI
    
    var body: some View {
        VStack {
            if userAuth.isLoggedIn {
                HomeTabView()
            }else {
                LoginView()
            }
        }
    }
}
