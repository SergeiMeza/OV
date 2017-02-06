//
//  UIKit Extensions 5.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

public extension UIViewController {
   
   public func presentAlert(_ message: String, hasCancelAction: Bool = false, okHandler: ((UIAlertAction)->())? = nil, cancelHandler: ((UIAlertAction)->())? = nil) {
      let alertVC = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
      if hasCancelAction {
         let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: cancelHandler)
         alertVC.addAction(cancelAction)
      }
      let okAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: okHandler)
      alertVC.addAction(okAction)
      
      present(alertVC, animated: true, completion: nil)
   }
   
   public func alertWith(_ title: String, _ message: String) -> UIAlertController {
      let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
      alertController.addAction(.init(title: "OK", style: .cancel))
      return alertController
   }
   
   
}


public extension UIViewController {
   public var v: View { return view }
}
