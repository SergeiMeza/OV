//
//  UIColor+extensions.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/30.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

extension UIColor {
   
   func colorWithBrightness(_ brightnessComponent: CGFloat) -> UIColor? {
      
      var hue : CGFloat = 0
      var saturation: CGFloat = 0
      var brightness: CGFloat = 0
      var alpha: CGFloat = 0
      
      self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
      
      print("hue \(hue)\n saturation \(saturation)\n brightness \(brightness)\n alpha \(alpha)\n")
      
      let newColor = UIColor(hue: hue,
                             saturation: saturation,
                             brightness: brightness * brightnessComponent,
                             alpha: alpha)
      return newColor
   }
   
   func colorWithHueOffset(_ hueOffset: CGFloat) -> UIColor {
      
      var hue : CGFloat = 0
      var saturation: CGFloat = 0
      var brightness: CGFloat = 0
      var alpha: CGFloat = 0
      
      self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
      let newHue = fmod(hue + hueOffset, 1)
      
      print("newHue \(newHue)")
      
      return UIColor(hue: newHue,
                     saturation: saturation,
                     brightness: brightness,
                     alpha: alpha)
   }
}

