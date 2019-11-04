//
//  NavigationBarConfigurator.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//
import SwiftUI

struct AppMainNavigationBar: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { nc in
        nc.navigationBar.barTintColor = .aetniaBlue
        nc.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font: UIFont(name: "Arial-BoldItalicMT", size: 36)
        ]
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<AppMainNavigationBar>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppMainNavigationBar>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
//        self.accentColor(.aetniaBlue)
//        self.font(.title)
    }

}
