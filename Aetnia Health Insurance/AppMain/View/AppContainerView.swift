//
//  ContentView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct AppContainerView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State var showSplash: Bool = true
    @State var showedLoginPage: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var loginAnimation: Animation {
        Animation.easeInOut(duration: 0.5)
            .delay(1.5)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            if showSplash && userAuth.userDefaults.stayLoggedIn && userAuth.userDefaults.savedUser != nil && !showedLoginPage {
                SplashScreen(duration: 1.5)
                    .onAppear {
                        withAnimation(self.loginAnimation) {
                            self.showSplash.toggle()
                        }
                }
                
            }else {
                if self.userAuth.isLoggedIn {
                    AppMainTabView().environmentObject(userAuth)
                        .transition(.opacity)
                }else {
                    withAnimation(loginAnimation) {
                        LoginView()
                            .transition(.opacity)
                            .accentColor(Color(.label))
                            .onAppear {
                                self.showedLoginPage = true
                        }
                    }
                }
            }
        }
    }
}
