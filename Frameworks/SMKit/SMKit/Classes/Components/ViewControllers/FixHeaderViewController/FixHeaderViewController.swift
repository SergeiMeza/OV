//
//  CustomTableViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

/// FixHeaderViewController is simply a UIViewController compose of a fixed header at top and a  UIViewController at the bottom
open class FixHeaderViewController: UIViewController {

   open var fixedHeaderView: UIView?
   open var datasourceViewController: UIViewController?
   open var headerHeight: CGFloat = 64
   
   open func setup(fixedHeaderView: UIView, datasourceViewController: UIViewController, headerHeight: CGFloat = 64) {
      self.fixedHeaderView = fixedHeaderView
      self.datasourceViewController = datasourceViewController
      self.headerHeight = headerHeight
   }
   
   open override func viewDidLoad() {
      super.viewDidLoad()
      
      if let fixedHeaderView = fixedHeaderView {
         
         view.addSubviews(fixedHeaderView, datasourceViewController!.view)
         
         fixedHeaderView.addAnchors(toTop: v.topAnchor,
                                    toRight: v.rightAnchor,
                                    toLeft: v.leftAnchor,
                                    height: headerHeight)
         
         datasourceViewController?.view.addAnchors(toTop: fixedHeaderView.bottomAnchor,
                                                        toRight: v.rightAnchor,
                                                        toBottom: v.bottomAnchor,
                                                        toLeft: v.leftAnchor)
      } else {
         
         view.addSubviews(datasourceViewController!.view)
         datasourceViewController?.view.fillSuperview()
      }
   }
}
