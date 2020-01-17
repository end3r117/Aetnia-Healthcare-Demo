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
    let doctorSearchViewModel: DoctorSearchViewModel = DoctorSearchViewModel()
    
    @State var showSplash: Bool = true
    
    var loginAnimation: Animation {
        Animation.easeInOut(duration: 0.5)
            .delay(1.5)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if showSplash {
                SplashScreen(duration: 0.5)
                    .onAppear {
                        withAnimation(self.loginAnimation) {
                                self.showSplash.toggle()
                        }
                }
            }else {
                if self.userAuth.isLoggedIn {
                    HomeTabView().environmentObject(doctorSearchViewModel).environmentObject(userAuth)
                            .transition(.opacity)
                }else {
                    withAnimation(loginAnimation) {
                        LoginView()
                            .transition(.opacity)
                        
                        
                    }
                    
                }
                
            }
        }
    }
}
