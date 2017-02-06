//
//  RearrangeDriver.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

protocol RearrangeDelegate:class {
   var currentRearrangeIndexPath: IndexPath? { get set } // hide and unhide
   func moveObjectAtCurrentRearrangeIndexPath(to indexPath: IndexPath) // resort datasource
   
}

class RearrangeDriver: NSObject {
   
   weak var delegate: RearrangeDelegate?
   
   weak var tableView: UITableView? {
      didSet {
         tableView?.addGestureRecognizer(longPress)
      }
   }
   
   internal var initialPosition: CGPoint? = .zero
   internal var gestureInitialPosition: CGPoint? = .zero
   internal var catchedView: UIImageView?
   internal var scrollSpeed: CGFloat = 0.0
   
   internal lazy var displayLink: CADisplayLink = { [unowned self] in
      let displayLink = CADisplayLink(target: self, selector: #selector(scrolled))
      displayLink.add(to: .main, forMode: .defaultRunLoopMode)
      displayLink.isPaused = true
      return displayLink
      }()
   
   internal lazy var longPress: UILongPressGestureRecognizer = { [unowned self] in
      let g = UILongPressGestureRecognizer()
      g.addTarget(self, action: #selector(longPressed))
      g.minimumPressDuration = 0.3
      g.delegate = self
      return g
   }()

   internal func moveCatchedViewTo(_ point: CGPoint) {
      guard  let catchedView = catchedView else {
         return
      }
      
      if let gestureInitialPosition = gestureInitialPosition, let initialPosition = initialPosition {
         catchedView.center.x = point.x - (gestureInitialPosition.x - initialPosition.x)
         catchedView.center.y = point.y - (gestureInitialPosition.y - initialPosition.y)
         moveDummyRowIfNeeded()
      }
   }
   
   private func moveDummyRowIfNeeded() {
      guard let tableView = tableView,
         let currentIndexPath = delegate?.currentRearrangeIndexPath,
         let catchedViewCenter = catchedView?.center,
         let newIndexPath = tableView.indexPathForRow(at: catchedViewCenter)
         else {
            return
      }
      
      if (newIndexPath != currentIndexPath) {
         delegate?.moveObjectAtCurrentRearrangeIndexPath(to: newIndexPath)
         delegate?.currentRearrangeIndexPath = newIndexPath
         
         tableView.beginUpdates()
         tableView.deleteRows(at: [currentIndexPath], with: .top)
         tableView.insertRows(at: [newIndexPath], with: .top)
         tableView.endUpdates()
      }
   }
   
   deinit {
      displayLink.invalidate()
   }

}

extension RearrangeDriver: UIGestureRecognizerDelegate {
   
   func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      // more code to come
      return true
   }
   
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return false
   }
}
