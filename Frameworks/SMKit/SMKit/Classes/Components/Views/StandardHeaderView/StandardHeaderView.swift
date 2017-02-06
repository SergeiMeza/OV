//
//  StandardHeaderView.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

open class StandardHeaderView: View {
   
   open let titleLabel: UILabel = {
      let l = UILabel.init()
      l.numberOfLines = 0
      l.text = "Hello World"
      l.textColor = UIColor.init(white: 0.05, alpha: 1)
      l.textAlignment = .center
      l.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
      return l
   }()
   
   open let rightButton: SMButton01 = {
      let b = SMButton01.init(type: .custom)
      return b
   }()
   
   open let leftButton: SMButton01 = {
      let b = SMButton01.init(type: .custom)
      b.isHidden = true
      return b
   }()
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .clear
      
      addSubviews(titleLabel, leftButton, rightButton)
      
      titleLabel.anchorCenterToSuperView()
      
      rightButton.addAnchors(toRight: rightAnchor, rightConstant: 8)
      rightButton.anchorCenterYToSuperview()
      
      leftButton.addAnchors(toLeft: leftAnchor, leftConstant: 8)
      leftButton.anchorCenterYToSuperview()
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
