//
//  AppDelegate.swift
//  Dribbble
//
//  Created by аймак on 25.08.17.
//  Copyright © 2017 Kaplya LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        window?.makeKeyAndVisible()
        window?.rootViewController = rootViewController()
        
        UIApplication.shared.statusBarStyle = .default
        return true
    }
    
}

