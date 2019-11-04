//
//  LoginTextField.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct LoginTextField: View {
    @Binding var text: String
    @State private var showClear: Bool = false
    
    var title: String
    var isPrivate: Bool
    var size: CGSize
    var roundedStyle: RoundedRectStyle.RoundedStyle
    
    var body: some View {
        ZStack {
            if !(isPrivate) {
                TextField(self.title, text: self.$text, onEditingChanged: { start in
                    if start {
                        //print("Editing began.")
                        self.showClear = true
                    }else {
                        //print("Done editing.")
                        self.showClear = false
                    }
                }, onCommit: {
                    print("Commit!")
                    self.showClear = false
                    })
                    .textFieldStyle(roundedStyle == .roundedTop ? RoundedRectStyle(roundedStyle: .roundedTop) : RoundedRectStyle(roundedStyle: .roundedBottom))
                    .autocapitalization(.none)
                    .frame(width: size.width, height: size.height)
                    .modifier(ClearButton(text: self.$text, visible: self.$showClear))
            }else {
                SecureField(self.title, text: self.$text)
                    .textFieldStyle(roundedStyle == .roundedTop ? RoundedRectStyle(roundedStyle: .roundedTop) : RoundedRectStyle(roundedStyle: .roundedBottom))
                    .autocapitalization(.none)
                    .frame(width: size.width, height: size.height)
            }
        }
    }
}

struct RoundedRectStyle: TextFieldStyle {
    enum RoundedStyle {
        case roundedTop
        case roundedBottom
    }
    
    var roundedStyle: RoundedStyle
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        GeometryReader { geo in
        configuration
            .padding(8)
            .background(
                Image(self.roundedStyle == .roundedTop ? ImageAssetName.usernameTextField : ImageAssetName.passwordTextField)
                    .resizable()
                    .frame(width: geo.size.width + 12, height: geo.size.height + 12)
                    .padding(EdgeInsets(top: 4, leading: -20, bottom: 4, trailing: 0))
            )
        }
    }
}
