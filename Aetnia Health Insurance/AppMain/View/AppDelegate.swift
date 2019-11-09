//
//  AppDelegate.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let userAuth = UserAuth()
    let userDefaults = UserDefaultsSwiftUI()
    var navConfig = NavConfig()
    var nav: MainNavigationController!
    var rootVC: UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITableView.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = .appColor(.aetniaBlue)
        
        
        let appMainView = AppMainView()
        let host = UIHostingController(rootView: appMainView.environmentObject(navConfig).environmentObject(userAuth).environmentObject(userDefaults))
        nav = MainNavigationController(rootViewController: host)
        nav.navigationBar.isHidden = true
        navConfig.navigationController = nav
        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        self.window = window
        self.window?.makeKeyAndVisible()
        
        
        return true
    }
}

class MainNavigationController: UINavigationController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        print("1. \(size.width > size.height ? "landscape" : "portrait")")
        let orientation = Orientation.getOrientation(from: size)
        NotificationCenter.default.post(name: .rotationEngaged, object: nil, userInfo: ["orientation":orientation])
    }
    
}

enum Orientation: String {
    case landscape, portrait
    
    static func getOrientation(from size: CGSize) -> Orientation {
        if size.width > size.height {
            return .landscape
        }else {
            return .portrait
        }
    }
}
