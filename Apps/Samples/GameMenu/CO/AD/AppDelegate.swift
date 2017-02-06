//
//  AppDelegate.swift
//  GameMenu
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

var currentTheme = Theme.fuschia

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   lazy var navController: UINavigationController = {
      let nc = UINavigationController(rootViewController: MenuViewController())
      nc.setNavigationBarHidden(true, animated: false)
      nc.navigationBar.barTintColor = UIColor.init(white: 0.95, alpha: 1)
      nc.navigationBar.tintColor = .black
      nc.navigationBar.isTranslucent = false
      return nc
   }()
}

extension AppDelegate {
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      setupApp()
      setupWindow()
      return true
   }
   
   func setupWindow() {
      window = UIWindow()
      window?.makeKeyAndVisible()
      window?.rootViewController = navController
   }
   
   func setupApp() {
      logger.setup(isDebugMode: true)
      logger.log(value: "Logging Started \(Date())")
      OneVision.App.setup(appName: "MainMenu01", appID: "1084478438", version: "1.0")
   }
}
