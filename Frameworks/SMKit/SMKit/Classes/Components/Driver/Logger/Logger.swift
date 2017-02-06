//
//  Logger.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import Foundation


/**
   Convenient Logger
 
   Features:
   - Turn on/off with one line of code
   - Easily readable in console
 
   Usage:
   - Create one global instance and use anywhere across your project
   - Set up at AppDelegate application(application,didFinishLaunchingWithOptions) method

 */
open class Logger {
   
   private var isDebugMode : Bool
   
   public init() {
      isDebugMode = false
   }
   
   /// Default debug mode is false
   open func setup(isDebugMode: Bool) {
      self.isDebugMode = isDebugMode
      print("LOG: project is debugMode: \(self.isDebugMode)")
   }
   
   
   /// Use the following method to print information into the console.
   open func log<T>(value: T) {
      if isDebugMode {
         print("\nLOG: \(value)\n")
      }
   }
}
