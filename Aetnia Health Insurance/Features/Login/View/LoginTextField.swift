//
//  LoginTextField.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import UIKit

struct LoginTextField: View {
    @Binding var text: String
    @State var privateText: String = ""
    @State private var showClear: Bool = false
    
    var title: String
    var isPrivate: Bool
    var size: CGSize
    var roundedStyle: RoundedStyle
    
    var body: some View {
        ZStack {
            if !(isPrivate) {
                TextField(self.title, text: self.$text, onEditingChanged: { start in
                    if start {
                        self.showClear = true
                    }else {
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
                    .modifier(ClearButton(text: self.$text, visible: self.$showClear))
            }
        }
    }
}
enum RoundedStyle {
    case roundedTop
    case roundedBottom
}
struct RoundedRectStyle: TextFieldStyle {
    
    
    var roundedStyle: RoundedStyle
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        GeometryReader { geo in
            configuration
                .padding(8)
                .background(
                    (self.roundedStyle == .roundedTop ? RoundedRect(style: .roundedTop) : RoundedRect(style: .roundedBottom))
                        .fill()
                        .shadow(color: Color(UIColor.rgb(red: 160, green: 160, blue: 160, alpha: 0.3)), radius: 7, x: 0.5, y: 0.5)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .frame(width: geo.size.width + 8, height: geo.size.height)
                        .padding(EdgeInsets(top: 4, leading: -20, bottom: 4, trailing: -20))
            )
        }
    }
}

struct RoundedRect: Shape {
    var style: RoundedStyle
    var corners: [UIRectCorner] {
        get {
            if self.style == .roundedTop {
                return [.topLeft, .topRight]
            }else {
                return [.bottomLeft, .bottomRight]
            }
        }
    }
    func path(in rect: CGRect) -> Path {
        return Path(UIBezierPath(roundedRect: rect, byRoundingCorners: [corners[0], corners[1]], cornerRadii: CGSize(width: 20, height: 20)).cgPath)
    }
}
