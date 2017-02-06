//
//  AppDelegate.swift
//  TransparentNavigationController
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      window = UIWindow()
      window?.makeKeyAndVisible()
      
      window?.rootViewController = TransparentNavigationController(rootViewController: ExampleViewController())
      
      
      UIApplication.shared.statusBarStyle = .lightContent
         
      return true
   }
}







