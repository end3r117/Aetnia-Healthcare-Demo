//
//  UITextView+ViewRepresentable.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct SwiftUITextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var height: CGFloat
    
    var address: String
    
    init(address: String, height: Binding<CGFloat>) {
        self._height = height
        self.address = address
    }
    
    func makeUIView(context: UIViewRepresentableContext<SwiftUITextView>) -> UITextView {
        let tv = UITextView()
        tv.textContainer.maximumNumberOfLines = 0
        tv.textAlignment = .center
        tv.isEditable = false
        tv.isSelectable = true
        tv.dataDetectorTypes = [.address]
        tv.text = self.address
        tv.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return tv
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<SwiftUITextView>) {
        uiView.centerVertically()
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
     
    
}
