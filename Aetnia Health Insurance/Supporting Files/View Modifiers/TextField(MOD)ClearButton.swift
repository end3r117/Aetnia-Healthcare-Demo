//
//  TextField(MOD)ClearButton.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    @Binding var visible: Bool
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .overlay(Button(action: {
                    self.text = ""
                }) {
                    if text != "" && visible {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12))
                    }
                }, alignment: .trailing)
        }
    }
}

