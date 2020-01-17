//
//  ContactButton.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/10/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct ContactButton: View {
    @EnvironmentObject var navConfig: NavConfig
    var text: String
    var size: CGSize
    var textColor: Color
    var backgroundColor: Color
    var icon: Image
    var disabled = false
    var additionalPaddingForIcon: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .fill()
                    .foregroundColor(backgroundColor)
                Button(action: {
                    self.action?()
                }, label: {
                HStack {
                    Spacer()
                        .frame(width: 8)
                    icon
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .foregroundColor(textColor)
                        .padding(self.additionalPaddingForIcon)
                        .clipped()
                    Rectangle()
                        .stroke()
                        .frame(width: 0.5)//, height: 48) //size.width / 8.1)
                        .padding()
                        .foregroundColor(textColor)
                    Text(text)
                        //.frame(width: size.width * 0.5)
                        .frame(width: 200)
                        .foregroundColor(textColor)
                        .lineLimit(0)
                        .padding()
                    Spacer()
                }
            })
                
                if disabled {
                    RoundedRectangle(cornerRadius: 8, style: .circular)
                        .fill()
                        .foregroundColor(Color(.lightGray))
                        .opacity(0.5)
                        .disabled(true)
                }
            }.padding(4)
        }.frame(maxWidth: 300, maxHeight: 44)
            .scaleEffect(self.navConfig.orientation == .portrait ? 0.8 : 1)
    }
}

/*
 icon
 .resizable()
 .scaledToFit()
 .frame(maxHeight: size.width / 8)
 .foregroundColor(textColor)
 .padding()
 */

/*
 Rectangle()
 .stroke()
 .frame(width: 0.5, height: size.width / 8.1)
 .padding()
 */
