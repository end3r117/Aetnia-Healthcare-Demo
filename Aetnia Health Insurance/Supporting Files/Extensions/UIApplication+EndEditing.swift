//
//  UIApplication+EndEditing.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
