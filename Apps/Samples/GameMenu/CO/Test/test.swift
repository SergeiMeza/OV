//
//  test.swift
//  GameMenu01
//
//  Created by Jeany Sergei Meza Rodriguez on 2016/10/27.
//  Copyright © 2016 OneVision. All rights reserved.
//

import SMKit

// not presenting right now...

class TestVC: UIViewController {
   
   
   lazy var themeButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.setProperties(image: #imageLiteral(resourceName: "pallete_small"), buttonImage: #imageLiteral(resourceName: "button_small"),
                      color: colors(currentTheme)![ThemeColor.btnClear]!,
                      buttonColor: colors(currentTheme)![ThemeColor.btnDark]!,
                      shadowColor: colors(currentTheme)![ThemeColor.btnShadow]!)
      b.contentMode = .scaleAspectFit
      return b
      }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      logger.log(value: "Presenting TestVC")
      currentTheme = .coquillage
      view.bg = colors(currentTheme)![ThemeColor.bg]!
      view.addSubview(themeButton)
      Constraint.center(themeButton)
   }
}
