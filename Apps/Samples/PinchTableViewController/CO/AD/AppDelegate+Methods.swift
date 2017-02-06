//
//  AppDelegate+Methods.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

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

