//
//  NavigationBarConfigurator.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//
import SwiftUI

class NavConfig: ObservableObject {
    var navigationController: UINavigationController!
    var rootVC: UIViewController!
    var appDelegate: AppDelegate!
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceTurned(_:)), name: .rotationEngaged, object: nil)
    }
    
    @Published var orientation: Orientation = .portrait
    @Published var barStyle: UIBarStyle = .default
    @Published var barTintColor: UIColor = .appColor(.aetniaBlue)
    @Published var backgroundColor: UIColor = .appColor(.aetniaBlue)
    @Published var titleTextAttributes: [NSAttributedString.Key: Any] = [
               .foregroundColor : UIColor.white,
               .font: UIFont(name: "Arial-BoldItalicMT", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
           ]
    var fontSize: CGFloat = 34 {
        didSet {
            titleTextAttributes = [
                .foregroundColor : UIColor.white,
                .font: UIFont(name: "Arial-BoldItalicMT", size: fontSize) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
            ]
        }
    }
    
    func config() {
        navigationController.navigationBar.barStyle = barStyle
        navigationController.navigationBar.barTintColor = barTintColor
        navigationController.navigationBar.backgroundColor = backgroundColor
        navigationController.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    @objc func deviceTurned(_ notification: Notification) {
        if let dict = notification.userInfo as? [String:Orientation], let orientation = dict["orientation"] {
            self.orientation = orientation
            print("New orientation: \(orientation.rawValue)")
            DispatchQueue.main.async {
                self.config()
            }
        }
    }
}

struct AppMainNavigationBar: UIViewControllerRepresentable {
    @EnvironmentObject var navConfig: NavConfig
    
    var configure: (UINavigationController, NavConfig) -> Void = { nc, navConfig in
        nc.navigationBar.barStyle = navConfig.barStyle
        nc.navigationBar.barTintColor = navConfig.barTintColor
        nc.navigationBar.backgroundColor = navConfig.backgroundColor
        nc.navigationBar.titleTextAttributes = navConfig.titleTextAttributes
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<AppMainNavigationBar>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppMainNavigationBar>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc, self.navConfig)
        }
    }

}
