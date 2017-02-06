//
//  PinchDriver+PinchBegan.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

/// COMMENT: properties
extension PinchGestureDriver {
   
   func pinched(_ g: UIPinchGestureRecognizer) {
      switch g.state {
      case.began: pinchBegan(g)
      case .changed: pinchChanged(g)
      case .ended: pinchEnded(g)
      default: logger.log(value: g.state.rawValue)
      }
   }
}

extension PinchGestureDriver {
   
   func pinchBegan(_ g: UIPinchGestureRecognizer) {
      
      guard let tableView = tableView, tableView.numberOfRows(inSection: 0) >= 1 else {
         logger.log(value: "check tableView")
         return
      }
      guard !isPinchBegan && g.numberOfTouches == 2 else {
         logger.log(value: "check logic")
         return
      }
      
      isPinchBegan = true
      
      let t1 = g.location(ofTouch: 0, in: tableView)
      let t2 = g.location(ofTouch: 1, in: tableView)
      
      points = CGRect.normalize(points: t1, t2)
      originalCenter = CGRect.center(of: t1, t2)
      
      guard let _ = tableView.indexPathForRow(at: points!.first!) else {
         logger.log(value: "check points")
         return
      }
      
      upperVisibleRowsIndexPaths = []
      lowerVisibleRowsIndexPaths = []
      
      if let ip = tableView.indexPathForRow(at: originalCenter!),
         let cell = tableView.cellForRow(at: ip) {
         let touchPosition = cell.frame.touchLocation(at: originalCenter!)
         switch touchPosition {
         case .lowerHalf:
            // get indexPaths
            for indexPath in tableView.indexPathsForVisibleRows! {
               if indexPath.row <= ip.row {
                  upperVisibleRowsIndexPaths?.append(indexPath)
               } else {
                  lowerVisibleRowsIndexPaths?.append(indexPath)
               }
            }
         case .upperHalf:
            for indexPath in tableView.indexPathsForVisibleRows! {
               if indexPath.row < ip.row {
                  upperVisibleRowsIndexPaths?.append(indexPath)
               } else {
                  lowerVisibleRowsIndexPaths?.append(indexPath)
               }
            }
         }
         insertionIndexPath = lowerVisibleRowsIndexPaths?.first
      } else {
         // add at end of table...
         // more code to come
      }
      
      if let lowerVisibleRowsIndexPaths = lowerVisibleRowsIndexPaths, lowerVisibleRowsIndexPaths.count > 0 {
         if let nextCell = tableView.cellForRow(at: lowerVisibleRowsIndexPaths.first!) {
            dummyView.frame = .make(0,
                                    nextCell.frame.upLeftCorner.y - 22,
                                    tableView.w,
                                    44)
            tableView.insertSubview(dummyView, at: 0)
         }
      }
   }
   
}
   
extension PinchGestureDriver {
   
   func pinchChanged(_ g: UIPinchGestureRecognizer) {
      
      if g.numberOfTouches == 2 && isPinchBegan {
         let t1 = g.location(ofTouch: 0, in: tableView)
         let t2 = g.location(ofTouch: 1, in: tableView)
         let movingPoints = CGRect.normalize(points: t1, t2)
         
         upperDelta = min(0,movingPoints[0].y-points![0].y) // >0
         lowerDelta = max(0, movingPoints[1].y-points![1].y) // <0
         
         guard let tableView = tableView, let upperVisibleRowsIndexPaths = upperVisibleRowsIndexPaths else {
            logger.log(value: "check logic")
            return
         }
         if !(upperVisibleRowsIndexPaths.isEmpty) {
            
            // adjust cell frame positions
            
            for index in 0..<tableView.visibleCells.count {
               let cell = tableView.visibleCells[index]
               if index <= upperVisibleRowsIndexPaths.last!.row {
                  cell.moveBy(x: 0, y: upperDelta)
               } else {
                  cell.moveBy(x: 0, y: lowerDelta)
               }
            }
            
            // animate dummy view
            
            dummyView.moveBy(x: 0, y: (lowerDelta + upperDelta)/2)
            dummyView.alpha = min(1, max(0.2, (abs(upperDelta)+abs(lowerDelta)-dummyView.h)/2/44))
         }
      }
   }
}

extension PinchGestureDriver {
   
   func pinchEnded(_ g: UIPinchGestureRecognizer) {
      
      guard isPinchBegan,
         let tableView = tableView,
         let upperVisibleRowsIndexPaths = upperVisibleRowsIndexPaths,
         upperVisibleRowsIndexPaths.count > 0 else { return }
      
      isPinchBegan = false
      
      // animate
      
      if abs(upperDelta) + abs(lowerDelta) >= 44 {
         func addNewRowInBetweenAnimation() {
            for index in 0..<tableView.visibleCells.count {
               let cell = tableView.visibleCells[index]
               if index <= upperVisibleRowsIndexPaths.last!.row {
                  cell.moveBy(x: 0, y: -44/2)
               } else {
                  cell.moveBy(x: 0, y: 44/2)
               }
            }
            dummyView.identity()
         }
         
         func completion() {
            dummyView.removeFromSuperview()
            for index in 0..<tableView.visibleCells.count {
               let cell = tableView.visibleCells[index]
               cell.identity()
            }
            tableView.reloadData()
            // more code to come!!
            
         }
         
         UIView.animate(withDuration: 0.2, animations: {
            addNewRowInBetweenAnimation()
         }) { (_) in
            completion()
         }
      } else {
         
         func animation() {
            for index in 0..<tableView.visibleCells.count {
               let cell = tableView.visibleCells[index]
               cell.identity()
            }
            dummyView.identity()
         }
         
         func completion() {
            dummyView.removeFromSuperview()
            for index in 0..<tableView.visibleCells.count {
               let cell = tableView.visibleCells[index]
               cell.identity()
            }
            tableView.reloadData()
         }
         
         UIView.animate(withDuration: 0.2, animations: {
            animation()
         }, completion: { (_) in
            completion()
         })
      }
   }
}











