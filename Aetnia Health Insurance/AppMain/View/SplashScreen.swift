//
//  SplashScreen.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    @State var imageOpacity: Double = 0.03
    var duration: Double
    
    var animation: Animation {
        Animation.easeIn(duration: duration)
    }
    
    var body: some View {
        ZStack {
            Image(.caduceus)
                .resizable()
                .scaledToFit()
                .opacity(imageOpacity)
                .onAppear {
                    withAnimation(self.animation) {
                        self.imageOpacity = 0.1
                    }
            }
            GeometryReader { geo in
                VStack {
                    Text(verbatim: "Aetnia")
                        .font(Font.custom("Arial", size: 80).italic().bold())
                        .foregroundColor(.aetniaBlue)
                    
                }.padding(.bottom, geo.size.height / 4)
            }
            
        }
    }
}
