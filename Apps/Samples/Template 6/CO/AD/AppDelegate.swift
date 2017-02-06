//
//  AppDelegate.swift
//  Template 6
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/30.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      setupWindow()
      
      return true
   }
}


// MARK: -


extension AppDelegate
{
   
   
   func setupWindow() {
      
      logger.setup(isDebugMode: true)
      window = UIWindow()
      
      window?.makeKeyAndVisible()
      
      window?.rootViewController = ViewController()
      
   }
   
}


