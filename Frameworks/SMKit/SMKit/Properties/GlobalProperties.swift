//
//  GlobalProperties.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import Foundation

public let logger = Logger()

public var deviceIdiom: UIUserInterfaceIdiom {return UIDevice.current.userInterfaceIdiom }
public var bateryLevel: Float { return UIDevice.current.batteryLevel }

public var userDefaults: UserDefaults { return UserDefaults.standard }


public var userMail: String? {
   didSet {
      userDefaults.set(userMail, forKey: User.emailKey)
   }
}

public var appUseCount: Int { return userDefaults.integer(forKey: User.appUseCount)}
public var isReviewed: Bool { return userDefaults.bool(forKey: User.isAppReviewed)}
public var isPresentedWalkthrought: Bool { return userDefaults.bool(forKey: User.isPresentedWalkthrought)}



















public struct User {
   public static let emailKey = "User.email"
   public static let isAppReviewed = "User.isAppReviewed"
   public static let isPresentedWalkthrought = "User.isPresentedWalkthrought"
   public static let appUseCount = "User.appUseCount"
}

public struct Theme {
   public struct Font {
      public static let myAppFont = "MyriadPro-BoldCond"
      // also add MyriadPro-BoldCond.ttf to plist file!
      public static let myTextFont = "AvenirNextCondensed-Regular"
      public static let myTextFontBold = "AvenirNextCondensed-Bold"
   }
}

public struct OneVision {
   
   public struct Company {
      public static let contactEmail = "contact.1visionstudio@gmail.com"
      public static let OVTwitterAccount = "1VisionStudio"
      
      public static var apps: [(appName:String, description: String, appID:String)] = [
         (NSLocalizedString("App.PlusOne.name", comment: "PlusOne"),
          NSLocalizedString("App.PlusOne.description", comment: "PlusOne: An app that counts for you"),
          "1154862456"),
         
         (NSLocalizedString("App.MrSlider.name", comment: "Mr Slider"),
          NSLocalizedString("App.MrSlider.description", comment: "MrSlider: Are you ready to enjoy?"),
          "1084478438")
      ] // setup on AppDelegate at launch
      
      
      
      public static func setup(appendApps appInfos: (appName:String, description: String, appID:String)...) {
         for (a,b,c) in appInfos {
            apps.append((a,b,c))
         }
      }
   }
   
   public struct App {
      public static var appName = "AppName" // setup on AppDelegate at launch
      public static var version = "1.0" // setup on AppDelegate at launch
      public static var appID = "12345678" // setup on AppDelegate at launch
      
      public static func setup(appName name:String, appID id: String, version: String) {
         App.appName = name
         App.version = version
         App.appID = id
      }
   }
   public struct AboutMenu {
      public static let description = NSLocalizedString("aboutMenu.description", comment: "")
      public struct Button {
         public static let apps = NSLocalizedString("aboutMenu.ourApps", comment: "")
         public static let review = NSLocalizedString("aboutMenu.review", comment: "")
         public static let follow = NSLocalizedString("aboutMenu.follow", comment: "")
         public static let newsletter = NSLocalizedString("aboutMenu.newsletter", comment: "")
         public static let contact = NSLocalizedString("aboutMenu.contact", comment: "")
         public static let tutorial = NSLocalizedString("aboutMenu.tutorial", comment: "")
      }
   }
   
   public struct ReviewMenu {
      public static let ask = NSLocalizedString("reviewMenu.ask", comment: "")
      public static let go = NSLocalizedString("reviewMenu.go", comment: "")
      public static let later = NSLocalizedString("reviewMenu.later", comment: "")
   }
   
   public struct ErrorMessages {
      public static let tryAgain = NSLocalizedString(".error.tryAgain", comment: "")
      public static let followTryAgain = NSLocalizedString(".error.follow.tryAgain", comment: "")
      public static let contactUs = NSLocalizedString(".error.contactUs", comment: "Oops! Could not send Email")
   }
   
   public struct Messages {
      public static let thanks = NSLocalizedString(".thanks", comment: "")
      public static let followThanks = NSLocalizedString(".thanks.follow", comment: "")
      public static let twitterAccess = NSLocalizedString("access.twitter", comment: "Please authorize access to Twitter accounts.")
      public static let cancel = NSLocalizedString(".cancel", comment: "")
      public static let ok = NSLocalizedString(".ok", comment: "")
      public static let subscribe = NSLocalizedString(".subscribe", comment: "")
      
   }
}


//      public static







