//
//  RearrangeDriver+LongPressMethosd.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

extension RearrangeDriver {
   
   func scrolled() {
      guard let tableView = tableView else {
         return
      }
      
      tableView.contentOffset.y = min(max(0, tableView.contentOffset.y + scrollSpeed),
                                      tableView.contentSize.height - tableView.frame.height)
      
      let loc = longPress.location(in: tableView)
      moveCatchedViewTo(loc)
   }
   
   func longPressed() {
      guard let tableView = tableView, !(tableView.isEditing) else {
         return
      }
      
      let location = longPress.location(in: tableView)
      
      switch longPress.state {
      case .began:
         longPressBegan(loc: location)
      case .changed:
         longPressChanged(loc: location)
      default:
         longPressDefault()
      }
   }
   
   private func longPressBegan(loc: CGPoint) {
      guard let tableView = tableView, !(tableView.isEditing) else {
         return
      }
      
      delegate?.currentRearrangeIndexPath = tableView.indexPathForRow(at: loc)
      guard let currentIndexPath = delegate?.currentRearrangeIndexPath,
         let catchedCell = tableView.cellForRow(at: currentIndexPath) else {
            return
      }
      
      tableView.allowsSelection = false
      catchedCell.isHighlighted = false
      
      // make an image from the pressed tableview cell
      let sizeWithoutSeparator = CGSize.make(catchedCell.bounds.width,
                                             catchedCell.bounds.height - 1)
      UIGraphicsBeginImageContextWithOptions(sizeWithoutSeparator,
                                             true,
                                             0)
      
      guard let context = UIGraphicsGetCurrentContext() else { return }
      catchedCell.layer.render(in: context)
      catchedView = UIImageView.init(image: UIGraphicsGetImageFromCurrentImageContext())
      UIGraphicsEndImageContext()
      
      guard let catchedView = catchedView else {
         return
      }
      
      // create and image view that we will drag around the screen
      catchedView.center = catchedCell.center
      initialPosition = catchedView.center
      gestureInitialPosition = loc
      tableView.addSubview(catchedView)
      
      // add drop shadow to image and lower opacity
      setupCatchedView(loc: loc)
      catchedCell.isHidden = true
   }
   
   private func setupCatchedView(loc: CGPoint) {
      guard let catchedView = catchedView else {
         return
      }
      catchedView.layer.shadowRadius = 4.0
      catchedView.layer.shadowOpacity = 0.25
      catchedView.layer.shadowOffset = .zero
      catchedView.layer.shadowPath = UIBezierPath(rect: catchedView.bounds).cgPath
      
      UIView.animate(withDuration: 0.2) { [unowned self] in
         catchedView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
         self.moveCatchedViewTo(loc)
      }
   }
   
   private func longPressChanged(loc: CGPoint) {
      guard let tableView = tableView, let catchedView = catchedView else {
         return
      }
      
      moveCatchedViewTo(loc)
      
      // improve this code
      scrollSpeed = 0
      
      if tableView.contentSize.height > tableView.frameHeight {
         
         let halfCellHeight = 0.5*catchedView.frameHeight
         let cellCenterY = catchedView.center.y - tableView.bounds.origin.y
         
         if cellCenterY < halfCellHeight {
            
            scrollSpeed = 5.0*(cellCenterY/halfCellHeight - 1.1)
         } else if cellCenterY > tableView.frameHeight - halfCellHeight {
            
            scrollSpeed = 5.0*( (cellCenterY - tableView.frameHeight)/halfCellHeight + 1.1)
         }
         
         displayLink.isPaused = (scrollSpeed == 0)
      }
   }
   
   private func longPressDefault() {
      guard let tableView = tableView else {
         return
      }
      
      tableView.allowsSelection = true // check
      displayLink.isPaused = true
      scrollSpeed = 0
      
      guard let currentIndexPath = delegate?.currentRearrangeIndexPath, let catchedView = catchedView else {
         return
      }
      
      delegate?.currentRearrangeIndexPath = nil
      
      UIView.animate(withDuration: 0.2, animations: {
         catchedView.identity()
         catchedView.frame = tableView.rectForRow(at: currentIndexPath)
      }) { [unowned self] _ in
         
         catchedView.layer.shadowOpacity = 0
         
         UIView.animate(withDuration: 0.1, animations: {
            tableView.reloadData()
            tableView.layer.add(CATransition(), forKey: "reload")
            
         }) { [unowned self] (_) in
            catchedView.removeFromSuperview()
            self.catchedView = nil
         }
      }
   }
}
