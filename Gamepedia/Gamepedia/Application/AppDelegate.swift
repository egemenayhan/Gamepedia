//
//  AppDelegate.swift
//  Gamepedia
//
//  Created by Egemen Ayhan on 14.05.2020.
//  Copyright © 2020 Egemen Ayhan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TabBarInitialRoutable {

    var window: UIWindow?
    weak var tabbarController: TabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        routeToTabBar()
        return true
    }

}
