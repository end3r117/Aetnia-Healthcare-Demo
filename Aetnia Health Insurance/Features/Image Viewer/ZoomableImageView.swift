//
//  ZoomableImageView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/10/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct ZoomableImageView: View {
    @Binding var image: Image?
    @Binding var visible: Bool
    @State var scale: CGFloat = 1.0
    @State var currentPosition: CGPoint = .zero
    @State var newPosition: CGPoint = .zero
    
    func handlePanGesture(_ value: DragGesture.Value, ended: Bool = false) {
        let diff = value.translation.height / CGFloat(value.time.compare(Date()).rawValue)
        print(diff)
        if abs(diff) > 175 {
            withAnimation {
                visible.toggle()
            }
        }
        if ended {
            self.currentPosition = CGPoint(x: value.translation.width + self.newPosition.x, y: value.translation.height + self.newPosition.y)
            print(self.newPosition.x)
            self.newPosition = self.currentPosition
            
        }else {
            self.currentPosition = CGPoint(x: value.translation.width + self.newPosition.x, y: value.translation.height + self.newPosition.y)
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(.label))
                .opacity(0.96)
            VStack {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .frame(width: UIScreen.main.bounds.width)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            self.scale = value.magnitude
                        }
                )
                    .offset(x: self.currentPosition.x, y: self.currentPosition.y)
                    .gesture(DragGesture()
                        .onChanged { value in
                            self.handlePanGesture(value)
                    }
                    .onEnded { value in
                        self.handlePanGesture(value, ended: true)
                        }
                )
            }.clipped()
            .onTapGesture {
                withAnimation {
                    self.visible.toggle()
                }
            }
        }.frame(minWidth: UIScreen.main.bounds.width, maxWidth: .infinity, minHeight: UIScreen.main.bounds.height, maxHeight: .infinity)
        
    }
}

