//
//  PinchGestureRecognizer.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/10.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

/// COMMENT:
class PinchGestureDriver: NSObject {
   
   weak var vc: UIViewController?
   weak var tableView: UITableView? {
      didSet {
         tableView?.addGestureRecognizer(pinch)
         pinch.addTarget(self, action: #selector(pinched))
      }
   }
   
   var isActive: Bool = false
   var addNewRow: ((IndexPath)->())?
   
   internal var dummyView: View = {
      let v = UIView()
      v.bg = .red
      return v
   }()
   
   internal var pinch: UIPinchGestureRecognizer = {
      return UIPinchGestureRecognizer()
   }()
   
   internal var isPinchBegan: Bool = false
   
   internal var points: [CGPoint]?
   internal var originalCenter: CGPoint?
   
   internal var upperDelta: CGFloat = 0
   internal var lowerDelta: CGFloat = 0
   
   internal var upperVisibleRowsIndexPaths: [IndexPath]?
   internal var lowerVisibleRowsIndexPaths: [IndexPath]?
   internal var insertionIndexPath: IndexPath?
//   
//   override init() {
//      super.init()
//      
//   }
//
}
