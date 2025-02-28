//
//  SceneDelegate.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import UIKit
//import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let userAuth = UserAuth()
    let userDefaults = UserDefaultsSwiftUI()
    var navConfig = NavConfig()
    var nav: UINavigationController!
    var rootVC: UIViewController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
//        let appMainView = AppMainView()
//        nav = UINavigationController(rootViewController: UIHostingController(rootView: appMainView.environmentObject(navConfig).environmentObject(userAuth).environmentObject(userDefaults)))
//        nav.navigationBar.isHidden = true
//        navConfig.navigationController = nav
//        // Use a UIHostingController as window root view controller.
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = nav
//                //UIHostingController(rootView: appMainView.environmentObject(navConfig).environmentObject(userAuth).environmentObject(userDefaults))//.onTapGesture { window.endEditing(false)})
//            self.window = window
//            self.window?.makeKeyAndVisible()
//        }
        
        
//        let appMainView = UIHostingController(rootView: AppMainView().environmentObject(navConfig).environmentObject(userAuth).environmentObject(userDefaults))
        rootVC = UIViewController()
        rootVC.view.backgroundColor = .aetniaBlue
        
//        rootVC.addChild(appMainView)
//        rootVC.view.addSubview(appMainView.view)
//        appMainView.view.fillSuperview()
        
        nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.isHidden = true
        navConfig.navigationController = nav
        navConfig.rootVC = rootVC
        let avc = AppointmentsViewController()
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = avc
            //UIHostingController(rootView: appMainView.environmentObject(navConfig).environmentObject(userAuth).environmentObject(userDefaults))//.onTapGesture { window.endEditing(false)})
            window?.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

