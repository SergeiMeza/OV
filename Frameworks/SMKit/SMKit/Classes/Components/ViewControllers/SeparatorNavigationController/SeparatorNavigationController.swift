//
//  SeparatorNavigationController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

open class SeparatorNavigationController: UINavigationController {
   
   open let separatorView: UIView = {
      let v = UIView()
      v.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
      return v
   }()
   
   open var separatorHeight: CGFloat = 0 {
      didSet {
         constraint.constant = separatorHeight
         updateViewConstraints()
      }
   }
   
   fileprivate var constraint = Constraint.init() {
      didSet {
         updateViewConstraints()
      }
   }
   
   
   override open var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
   override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
      return .slide
   }
   
   public convenience init() {
      self.init(navigationBarClass: nil, toolbarClass: nil)
   }
   
   override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
      super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
   }
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override open func viewDidLoad() {
      super.viewDidLoad()
      self.navigationBar.addSubview(separatorView)
      
      Constraint.make(separatorView, .top, superView: .bottom, 1, -1)
      Constraint.make(separatorView, .width, superView: .width, 1, 0)
      
      constraint = Constraint.init(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: separatorHeight)
      constraint.isActive = true
   }
}
