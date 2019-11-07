//
//  View+AeniaBackground.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI



struct AetniaBackgroundViewModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        
        ZStack {
            content
        }.overlay(
            Image(.caduceus)
            .resizable()
            .scaledToFit()
                .opacity(0.05)
        )
        
    }
    
}
