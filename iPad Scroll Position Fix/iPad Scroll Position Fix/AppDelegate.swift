//
//  AppDelegate.swift
//  iPad Scroll Position Fix
//
//  Created by John Brayton on 2/18/18.
//  Copyright © 2018 John Brayton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let root = UINavigationController(rootViewController: TableViewController())
        window.rootViewController = root
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
    
}

