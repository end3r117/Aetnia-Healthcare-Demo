//
//  NavigationView(MOD)AetniaNavConfig.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/8/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct AetniaNavConfig: ViewModifier {
    @EnvironmentObject var userAuth: UserAuth
    @State var navTitle: String
    
    public func body(content: Content) -> some View {
        
            content
                .navigationBarTitle(Text(self.navTitle), displayMode: .inline)
                .transition(.opacity)
                .animation(.easeOut)
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
