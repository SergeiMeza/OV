//
//  TransparentNavigationController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

open class TransparentNavigationController: UINavigationController {
   
   open override func viewDidLoad() {
      super.viewDidLoad()
      setupNavCon()
   }
   
   internal func setupNavCon() {
      // navigationBar becomes transparent
      navigationBar.setBackgroundImage(UIImage(), for: .default)
      // DivisionLine becomes transparent
      navigationBar.shadowImage = UIImage()
   }
   
   // cannot set after object created :(
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return .default
   }
   
   // cannot set after object created :(
   open override var prefersStatusBarHidden: Bool {
      return true
   }
   
}
