//
//  AppDelegate.swift
//  TemplateApp4
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      setupApp()
      setupWindow()
      return true
   }
}

extension AppDelegate {
   
   func setupApp() {
      
      logger.setup(isDebugMode: true)
   }
   
   func setupWindow() {
      
      window = UIWindow()
      window?.makeKeyAndVisible()
      
      window?.rootViewController = ViewController()
      
   }
}
