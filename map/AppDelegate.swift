//
//  AppDelegate.swift
//  map
//
//  Created by USER on 2021/01/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = DefaultViewController.init()
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        self.window = window
        self.window?.rootViewController = rootViewController
        return true
    }
}
