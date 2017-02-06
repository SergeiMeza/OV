//
//  Model.swift
//  GameMenu01
//
//  Created by Jeany Sergei Meza Rodriguez on 2016/10/23.
//  Copyright © 2016 OneVision. All rights reserved.
//

import SMKit

let themesDictionary : NSDictionary? = {
   guard let path = Bundle.main.path(forResource: "themeColor", ofType: "plist") else {
      logger.log(value: "unable to load themeColor.plist")
      return nil
   }
   return NSDictionary.init(contentsOfFile: path)
}()

enum Theme: String {
   case fuschia = "fuschia", green = "green", red = "red", blue = "blue", yellow = "yellow", light = "light", dark = "dark"
   case fruitSalad = "fruit salad", coquillage = "coquillage", ratatouille = "ratatouille", ambassadeur = "ambassadeur"
   case sunset = "sunset", white = "white", black = "black", waterLily = "water lily", nuclear = "nuclear", nautilus = "nautilus"
   case hellfire = "hellfire", tiger = "tiger", thunderbolt = "thunderbolt", lipstick = "lipstick", mrFlap = "mr flap"
}

let myThemes: [Theme] = [.fuschia, .green, .red, .blue, .yellow, .light, .dark, .fruitSalad, .coquillage, .ratatouille,
                         .ambassadeur, .sunset, .white, .black, .waterLily, .nuclear, .nautilus, .hellfire, .tiger, .thunderbolt, .lipstick, .mrFlap]

func themes() -> [String:[String:Any]]? {
   return themesDictionary as? [String:[String:Any]]
}

func colors(_ theme: Theme) -> [String:UIColor]? {
   var colors: [String: UIColor] = [:]

   guard let themes = themes() else {
      return nil
   }
   
   for someTheme in themes {
      if theme.rawValue == someTheme.key {
         let colorsDict = someTheme.value
         for color in colorsDict {
            colors[color.key] = UIColor.rgb(color.value as! Int)
         }
      }
   }
   
   return colors
}

struct ThemeColor {
   static let bg = "bg"
   static let btn = "btn"
   static let btnText = "btn_text"
   static let btnClear = "btn_clear"
   static let btnDark = "btn_dark"
   static let btnShadow = "btn_shadow"
   static let string = "string"
}
