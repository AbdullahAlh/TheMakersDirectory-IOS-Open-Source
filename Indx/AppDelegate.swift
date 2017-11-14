//
//  AppDelegate.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/13/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        App.setup(window: window!, launchOptions: launchOptions ?? [:])
        
        return true
    }
    
    // MARK: deep linking
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return App.fire.links.handle(url: url)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return App.fire.links.handle(userActivity: userActivity)
    }
}

