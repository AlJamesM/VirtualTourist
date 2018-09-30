//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/18/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: Constants.Settings.ModelName)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        dataController.load()
        let navViewController = window?.rootViewController as! UINavigationController
        let mapViewController = navViewController.topViewController as! MapViewController
        mapViewController.dataController = dataController

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
}

extension AppDelegate {
    func saveViewContext() {
        try? dataController.viewContext.save()
    }
}
