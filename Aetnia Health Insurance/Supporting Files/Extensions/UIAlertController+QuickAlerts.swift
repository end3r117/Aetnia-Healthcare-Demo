//
//  UIAlertController+QuickAlerts.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/1/19.
//  Copyright © 2019 Anthony Rosario. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    enum UIAlertControllerQuickAlertTypes {
        case OK, Cancel, OKCancel, DeleteCancel
    }
    
    convenience init(quicklyUsing type: UIAlertControllerQuickAlertTypes, alertTitle: String?, alertMessage: String?, okayTitle: String = "Got it", cancelTitle: String = "Cancel", deleteTitle: String = "Delete", preferredStyle: UIAlertController.Style = .alert) {
        
        let okayAction = UIAlertAction(title: okayTitle, style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: deleteTitle, style: .destructive, handler: nil)
        
        self.init(title: alertTitle, message: alertMessage, preferredStyle: preferredStyle)
        
        switch type {
        case .OK:
            self.addAction(okayAction)
        case .Cancel:
            self.addAction(cancelAction)
        case .OKCancel:
            self.addAction(okayAction)
            self.addAction(cancelAction)
        case .DeleteCancel:
            self.addAction(deleteAction)
            self.addAction(cancelAction)
        }
    }
    
}
