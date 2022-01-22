//
//  AppDelegate.swift
//  PhotoApp
//
//  Created by Prakash on 21/01/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
               window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
               window?.makeKeyAndVisible()

        return true
    }


}

