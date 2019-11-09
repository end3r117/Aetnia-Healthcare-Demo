//
//  BEMCheckboxView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import UIKit
import BEMCheckBox


struct BEMCheckBoxView: UIViewRepresentable {
    
    @Binding var on: Bool
    
    
    func makeUIView(context: Context) -> BEMCheckBox {
        let cb = BEMCheckBox()
        
        cb.onFillColor = .appColor(.aetniaBlue)
        cb.onCheckColor = .systemBackground
        cb.offFillColor = .systemBackground
        cb.tintColor = .systemGray4
        cb.onTintColor = .aetniaBlue
        cb.onAnimationType = .bounce
        cb.offAnimationType = .fade
        cb.animationDuration = 0.3
        cb.boxType = .square
        
        //cb.addTarget(context.coordinator, action: #selector(Coordinator.didTap(_:)), for: .valueChanged)
        
        cb.delegate = context.coordinator
        
        return cb
    }
    

    func updateUIView(_ uiView: BEMCheckBox, context: Context) {
        uiView.on = self.on
        uiView.onFillColor = .appColor(.aetniaBlue)
        uiView.onCheckColor = .systemBackground
        uiView.offFillColor = .systemBackground
        uiView.tintColor = .systemGray4
        uiView.onTintColor = .aetniaBlue
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, BEMCheckBoxDelegate {
        var control: BEMCheckBoxView

        init(_ control: BEMCheckBoxView) {
            self.control = control
        }
        
        func animationDidStop(for checkBox: BEMCheckBox) {
            control.on = checkBox.on
        }
    }

    
    
}
