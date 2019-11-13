//
//  UITextView+ViewRepresentable.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct HyperlinkView: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var height: CGFloat
    
    var text: String
    var dataDetectorTypes: UIDataDetectorTypes
    
    init(text: String, height: Binding<CGFloat>, dataDetectorTypes: UIDataDetectorTypes) {
        self._height = height
        self.text = text
        self.dataDetectorTypes = dataDetectorTypes
    }
    
    func makeUIView(context: UIViewRepresentableContext<HyperlinkView>) -> UITextView {
        let tv = UITextView()
        tv.textContainer.maximumNumberOfLines = 0
        tv.textAlignment = .center
        tv.isEditable = false
        tv.isSelectable = true
        tv.dataDetectorTypes = self.dataDetectorTypes
        tv.text = self.text
        tv.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return tv
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<HyperlinkView>) {
        uiView.centerVertically()
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
     
    
}
