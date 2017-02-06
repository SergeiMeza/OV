//
//  JSONDriver.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class JSONDriver: NSObject {
   
   override init() {
      super.init()
      if let jsonURL = Bundle.main.url(forResource: "Clear", withExtension: "json") {
         if let jsonData = try? Data.init(contentsOf: jsonURL) {
            let json = JSON(data: jsonData)
            let info = json[Info.key]
            let dataVersion = json[AppData.key][AppData.version]
            let settings = json[AppData.key][AppData.Settings.key]
            let userLists = settings[AppData.Settings.Order.userLists.hashValue][UserLists.key]
            let sounds = settings[AppData.Settings.Order.sounds.hashValue][Sounds.key]
            let themes = settings[AppData.Settings.Order.themes.hashValue][Themes.key]
            let tips = settings[AppData.Settings.Order.tips.hashValue][Tips.key]
            let follow = settings[AppData.Settings.Order.follow.hashValue][Follow.key]
            let preferences = settings[AppData.Settings.Order.preferences.hashValue][Preferences.key]
         }
      }
      
//      
//      if let v1 = try? Data.init(contentsOf: Bundle.main.url(forResource: "appv1", withExtension: "json")!), let v2 = try? Data.init(contentsOf: Bundle.main.url(forResource: "appv2", withExtension: "json")!)  {
//         var v1J = JSON(data: v1), v2J = JSON(data: v2)
//         
//         let merged = try! v1J.merged(with: v2J)
//         
//         
//         v1J["app"]["version"].int = 2
//         
//         
//         logger.log(value: v1J)
//         logger.log(value: v2J)
//         logger.log(value: merged)
//      }
      
//      let levels = ["unlocked", "locked", "locked"]
//      let json = JSON(levels)
//      let str = json.description
//      let data = str.data(using: String.Encoding.utf8)!
//      let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//      var isDirectory: ObjCBool = false {
//         didSet {
//            logger.log(value: isDirectory)
//         }
//      }
//      logger.log(value: path)
//      let testPath = path.appendingPathComponent("test.json")
//      logger.log(value: testPath.absoluteString)
//      if !FileManager.default.fileExists(atPath: testPath.absoluteString, isDirectory: &isDirectory) {
//         logger.log(value: "not file at path")
//         if FileManager.default.createFile(atPath: testPath.absoluteString, contents: nil, attributes: nil) {
//            if let fileHandle = FileHandle(forWritingAtPath: testPath.absoluteString) {
//               fileHandle.write(data)
//            } else {
//               logger.log(value: "Unable to create file")
//            }
//         }
//      } else {
//         logger.log(value: "file exists at directory")
//         let fileHandle = try? FileHandle(forUpdating: testPath)
//         fileHandle?.write(data)
//      }
      
   }
}

/// Dictionary
struct Info {
   static let key = "info"
   /// Value
   static let jsonVersion = "jsonVersion"
   /// Value
   static let appVersion = "appVersion"
}

/// Dictionary
struct AppData {
   static let key = "data"
   /// Value
   static let version = "dataVersion"
   /// Array
   struct Settings {
      
      static let key = "Settings"
      enum Order {
         case userLists, sounds, themes, tips, follow, preferences
      }
   }
}

/// Array
struct UserLists {
   static let key = "My Lists"
   /// Dictionary
   struct List {
      /// Value
      static let listName = "listName"
      /// Array
      static let listObjects = "listObjects"
      /// Dictionary
      struct Task {
         /// Value
         static let name = "name"
         /// Value
         static let date = "date"
         /// Value
         static let state = "completed"
      }
   }
}

/// Array
struct Tips {
   static let key = "Tips & Tricks"
   /// Dictionary
   struct Tip {
      static let label = "label"
      static let description = "description"
   }
}

/// Array
struct Sounds {
   static let key  = "Sounds"
}

/// Array
struct Themes {
   static let key = "Themes"
}

// Array
struct Follow {
   static let key = "Follow the Team"
}

/// Array
struct Preferences {
   static let key = "Preferences"
   /// Dictionary
   struct Preference {
      static let label = "label"
      static let value = "value"
   }
}



/**
struct App {
   /// Dictionary
   struct Info {
      static let key = "info"
      /// Value
      static let jsonVersion = "jsonVersion"
      /// Value
      static let appVersion = "appVersion"
   }
   /// Dictionary
   struct Data {
      static let key = "data"
      /// Value
      static let version = "dataVersion"
      /// Array
      struct Settings {
         
         static let key = "Settings"
         enum Order:Int {
            case userLists=0, sounds=1, themes, tips, follow, preferences
         }
         
         /// Array
         struct UserLists {
            static let key = "My Lists"
            /// Dictionary
            struct List {
               /// Value
               static let listName = "listName"
               /// Array
               static let listObjects = "listObjects"
               /// Dictionary
               struct Task {
                  /// Value
                  static let name = "name"
                  /// Value
                  static let date = "date"
                  /// Value
                  static let state = "completed"
               }
            }
         }
         /// Array
         struct Sounds {
            static let key  = "Sounds"
         }
         
         /// Array
         struct Themes {
            static let key = "Themes"
         }
         
         /// Array
         struct Tips {
            static let key = "Tips & Tricks"
            /// Dictionary
            struct Tip {
               static let label = "label"
               static let description = "description"
            }
         }
         // Array
         struct Follow {
            static let key = "Follow the Team"
         }
         
         struct Preferences {
            static let key = "Preferences"
            struct Preference {
               static let label = "label"
               static let value = "value"
            }
         }
      }
   }
}
 
 
 */
