//
//  UIView+AddSubviews.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/11/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        if !views.isEmpty {
            for (_, v) in views.enumerated() {
                addSubview(v)
            }
        }
    }
    
    public func addSubviews(views: UIView..., translatesAutoResizingMaskIntoConstraints b: Bool) {
        views.forEach({$0.translatesAutoresizingMaskIntoConstraints = b})
        addSubviews(views)
    }
    
}

