//
//  LBTATextView.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

open class LBTATextView: UITextView {
   
   public init() {
      super.init(frame: .zero, textContainer: nil)
      backgroundColor = .clear
      isEditable = false
      isScrollEnabled = false
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

extension UIImage {
   var center: CGPoint {
      return CGPoint.make(size.width/2, size.height/2)
   }
}
