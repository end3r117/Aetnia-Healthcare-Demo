//
//  ActivityViewer.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/12/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct ActivityViewer: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    var activityItems: [Any]
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewer>) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewer>) {
        
    }
    
}
