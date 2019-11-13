//
//  AppDelegate.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import CoreData

func getAppDelegateCoreDataContext() -> NSManagedObjectContext {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate.persistentContainer.viewContext
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    let userDefaults = UserDefaultsSwiftUI()
    
    var navConfig = NavConfig()
    var nav: MainNavigationController!
    var rootVC: UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UITableView.appearance().backgroundColor = UIColor.clear
        //UINavigationBar.appearance().tintColor = .aetniaBlue
//        UINavigationBar.appearance().backgroundColor = .appColor(.aetniaBlue)
        
        let userAuth = UserAuth()
//        userAuth.logout()
        let appContainerView = AppContainerView()
        let host = UIHostingController(rootView: appContainerView.environmentObject(navConfig).environmentObject(userAuth))//.environmentObject(userDefaults)
        nav = MainNavigationController(rootViewController: host)
        nav.navigationBar.isHidden = true
        navConfig.appDelegate = self
        navConfig.navigationController = nav
        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = nav
        window.tintColor = .systemBackground
        self.window = window
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DocumentEntity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
    
    func opposite() -> Orientation {
        self == .portrait ? .landscape : .portrait
    }
    
    static func getOrientation(from size: CGSize) -> Orientation {
        if size.width > size.height {
            return .landscape
        }else {
            return .portrait
        }
    }
}
