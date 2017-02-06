//
//  AppDelegate.swift
//  PlusOne
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
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
   
   func applicationWillResignActive(_ application: UIApplication) {
      archiveFiles()
   }
   
   
   func applicationWillTerminate(_ application: UIApplication) {
      archiveFiles()
      soundsLoaded = false
   }
   
}

extension AppDelegate {
   func setupApp() {
      
      logger.setup(isDebugMode: false)
      
      OneVision.App.setup(appName: "PlusOne", appID: "1154862456", version: "1.3")
      
      userDefaults.set(appUseCount, forKey: User.appUseCount)
      
      soundsLoaded = true
      unarchiveFiles()
   }
   
   func setupWindow() {
      
      window = UIWindow()
      window?.makeKeyAndVisible()
      
      let navCon = UINavigationController.init(rootViewController: AppViewController())
      navCon.isNavigationBarHidden = true
      
      window?.rootViewController = navCon
   }
   
   func archiveFiles() {
      
      let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
      
      let namesPath = String(path) + AppKeys.names
      let countsPath = String(path) + AppKeys.counts
      let colorsPath = String(path) + AppKeys.colors
      let compradoPath = String(path) + AppKeys.comprado
      let soundsPath = String(path) + AppKeys.sounds
      let mailPath = String(path) + AppKeys.mail
      
      var names = [String]()
      var counts = [Int]()
      var colors = [UIColor]()
      for counter in counters {
         
         if counter.text == nil {
            names.append("SergeiMeza")
         } else {
            names.append(counter.text!)
         }
         
         counts.append(counter.count)
         colors.append(counter.color)
      }
      
      let _ = NSKeyedArchiver.archiveRootObject(names, toFile: namesPath)
      let _ = NSKeyedArchiver.archiveRootObject(counts, toFile: countsPath)
      let _ = NSKeyedArchiver.archiveRootObject(colors, toFile: colorsPath)
      let _ = NSKeyedArchiver.archiveRootObject(comprado, toFile: compradoPath)
      let _ = NSKeyedArchiver.archiveRootObject(areSoundsActive, toFile: soundsPath)
      if userMail != "" {
         _ = NSKeyedArchiver.archiveRootObject(userMail, toFile: mailPath)
      }
   }
   
   func unarchiveFiles() {
      
      let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
      let namesPath = String(path) + AppKeys.names
      let countsPath = String(path) + AppKeys.counts
      let colorsPath = String(path) + AppKeys.colors
      let compradoPath = String(path) + AppKeys.comprado
      let soundsPath = String(path) + AppKeys.sounds
      
      var names = [String?]()
      var counts = [Int]()
      var colors = [UIColor]()
      
      if let someNames = NSKeyedUnarchiver.unarchiveObject(withFile: namesPath) as? [String] {
         for name in someNames {
            if name == "SergeiMeza" {
               names.append("")
            } else {
               names.append(name)
            }
         }
      }
      
      if let someCounts = NSKeyedUnarchiver.unarchiveObject(withFile: countsPath) as? [Int] {
         counts += someCounts
      }
      
      
      if let someColors = NSKeyedUnarchiver.unarchiveObject(withFile: colorsPath) as? [UIColor] {
         colors += someColors
      }
      
      if ((!colors.isEmpty)&&(!counts.isEmpty)) {
         var someCounters = [Counter]()
         for i in 0...colors.count-1 {
            someCounters.append(Counter(color: colors[i], text: names[i], count: counts[i]))
         }
         counters = someCounters
      }
      
      if let bought = NSKeyedUnarchiver.unarchiveObject(withFile: compradoPath) as? Bool {
         comprado = bought
      }
      
      if let sounds = NSKeyedUnarchiver.unarchiveObject(withFile: soundsPath) as? Bool {
         areSoundsActive = sounds
         soundsLoaded = areSoundsActive
      }
   
   }
   
   

   

   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }

   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }

   


}

