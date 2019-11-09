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
        
        content
            .background(
                VStack {
                    Spacer()
                        .frame(maxHeight: UIScreen.main.bounds.height / 4)
                    AetniaBackground()
                }
        )
    }
    
}

struct AetniaBackground: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIImageView {
        let v = UIImageView(image: #imageLiteral(resourceName: "caduceus").withRenderingMode(.alwaysTemplate))
        v.tintColor = .appColor(.caduceus)
        v.alpha = 0.05
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = false
        v.backgroundColor = .clear
        return v
    }
    

    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }
    
}
