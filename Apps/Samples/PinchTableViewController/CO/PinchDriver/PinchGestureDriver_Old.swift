//
//  PinchGestureDriver.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/10.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

@objc protocol PinchAddDelegate:class {
   
   var dummyViewHeight:CGFloat {get set}
   
   func addNewObject(at atIndexPath: IndexPath, upperIndexPaths: [IndexPath], lowerIndexPaths: [IndexPath])
   
   @objc optional func addNewObjectAtEndOfTable(gesture: UIPinchGestureRecognizer)
}

internal struct PinchAddProperties {
   weak var delegate : PinchAddDelegate!
   let recognizer: UIPinchGestureRecognizer!
}

private protocol Pinchable:class { var properties: PinchAddProperties! {get set} }

class PinchAddController: NSObject {
   
   var isActive = false
   
   internal weak var vc: UITableViewController!
   internal weak var tableView: UITableView!
   
   internal var properties: PinchAddProperties!
   
   internal var originalPinchCenter: CGPoint?
   internal var points: (up:CGPoint,down:CGPoint)?
//   internal var dummyView: DummyView?
   
   internal var upperIndexPaths: [IndexPath]!
   internal var lowerIndexPaths: [IndexPath]!
   internal var insertionIndexPath: IndexPath!
   internal var upperDelta: CGFloat!
   internal var lowerDelta: CGFloat!
   
   internal var pinchedBegan = false
   
   internal var width : CGFloat {return vc.view.width}
}

extension PinchAddController: Pinchable {
   
   func setOptions(viewController: UITableViewController, delegate:PinchAddDelegate, isActive: Bool) {
      
      properties = PinchAddProperties(delegate: delegate, recognizer: UIPinchGestureRecognizer(target: self, action: #selector(pinched)))
      
      self.isActive = isActive
      
      vc = viewController
      tableView = vc.tableView
      tableView.addGestureRecognizer(properties.recognizer)
   }
   
   @objc private func pinched(gesture: UIPinchGestureRecognizer) {
      
      switch gesture.state {
      case.began: pinchedBegan(gesture: gesture)
      case .changed: pinchedChanged(gesture: gesture)
      case .ended: pinchedEnded(gesture: gesture)
      default: break
      }
   }
   
   private func pinchedBegan(gesture: UIPinchGestureRecognizer) {
      
      if isActive {
         
         if gesture.numberOfTouches == 2 && !pinchedBegan {
            pinchedBegan = true
            
            // 1. setup dummy view
            
            let dummyViewHeight = properties.delegate!.dummyViewHeight
            
            self.dummyView = DummyView(frame: CGRect(origin: CGPoint.zero,
                                                     size: CGSize(width: width, height: dummyViewHeight)))
            
            // 2. gather data
            
            upperIndexPaths = []
            lowerIndexPaths = []
            
            let touchOne = gesture.location(ofTouch:0,in:tableView)
            let touchTwo = gesture.location(ofTouch:1,in:tableView)
            points = CGRect.normalizedPoints(a:touchOne,b:touchTwo)
            
            originalPinchCenter = (points!.up+points!.down)/2
            
            // 2-1 check the upper touch is inside the table
            
            guard let _ = tableView.indexPathForRow(at:points!.up) else {return}
            
            if let catchedIndexPath=tableView.indexPathForRow(at:originalPinchCenter!), let catchedCell=tableView.cellForRow(at:catchedIndexPath) {
               
               let touchInRect = catchedCell.frame.touchLocation(at:originalPinchCenter!)
               switch touchInRect {
               case .lowerHalf :
                  for ip in tableView.indexPathsForVisibleRows! {
                     if ip.row <= catchedIndexPath.row {
                        upperIndexPaths.append(ip)
                     } else {
                        lowerIndexPaths.append(ip)
                     }
                  }
               case .upperHalf :
                  for ip in tableView.indexPathsForVisibleRows! {
                     if ip.row < catchedIndexPath.row {
                        upperIndexPaths.append(ip)
                     } else {
                        lowerIndexPaths.append(ip)
                     }
                  }
               }
               insertionIndexPath = lowerIndexPaths.first!
            } else {
               
               properties.delegate?.addNewObjectAtEndOfTable?(gesture: gesture)
               pinchedBegan = false
            }
            
            let followingCell = tableView.cellForRow(at: lowerIndexPaths.first!)!
            let color = followingCell.contentView.backgroundColor
            let dummyCellAnchor = followingCell.frame.upLeftCorner
            dummyView!.frame = CGRect(leftMiddle: dummyCellAnchor, size: dummyView!.size)
            dummyView!.backgroundColor = color
            dummyView!.infoLabel.text = pinchAddString
            tableView.insertSubview(dummyView!,at:0)
            
         }
      }
   }
   
   private func pinchedChanged(gesture: UIPinchGestureRecognizer) {
      
      if gesture.numberOfTouches == 2 && pinchedBegan {
         
         let dummyViewHeight = properties.delegate!.dummyViewHeight
         
         // 1. gather data
         
         let touchOne = gesture.location(ofTouch:0,in:tableView)
         let touchTwo = gesture.location(ofTouch:1,in:tableView)
         let currentPoints = CGRect.normalizedPoints(a:touchOne,b:touchTwo)
         
         upperDelta = min(0,currentPoints.up.y-points!.up.y) // is never negative
         lowerDelta = max(0,currentPoints.down.y-points!.down.y) // is never positive
         
         // 2. adjust frames
         
         let visibleCells = tableView.visibleCells
         for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if i <= upperIndexPaths.last!.row { cell.moveBy(x:0,y:upperDelta) // move upper block up
            } else { cell.moveBy(x:0,y:lowerDelta) } // move lower block down
         }
         
         if let dummyView = dummyView {
            dummyView.moveBy(x: 0, y: (upperDelta+lowerDelta)/2) // keep in between
            dummyView.alpha = min(1,max(0.2,((abs(upperDelta)+abs(lowerDelta)-dummyViewHeight/2)/properties.delegate!.dummyViewHeight))) // always between 0 and 1
            dummyView.infoLabel.text = abs(upperDelta)+abs(lowerDelta)-8<dummyViewHeight ? pinchAddString:releaseAddString
         }
      }
   }
   
   private func pinchedEnded(gesture:UIPinchGestureRecognizer) {
      
      if pinchedBegan {
         
         pinchedBegan = false
         
         let dummyViewHeight = properties.delegate!.dummyViewHeight
         
         if abs(upperDelta)+abs(lowerDelta) >= dummyViewHeight {
            func animation() {
               let visibleCells = tableView.visibleCells
               for i in 0..<visibleCells.count {
                  let cell = visibleCells[i]
                  if i <= upperIndexPaths.last!.row {
                     cell.moveBy(x:0,y:-dummyViewHeight/2)
                  } else {
                     cell.moveBy(x:0,y:+dummyViewHeight/2)
                  }
               }
               dummyView!.infoLabel.text = ""
               dummyView!.identity()
            }
            func completion() {
               dummyView?.removeFromSuperview()
               
               let visibleCells = tableView.visibleCells
               for i in 0..<visibleCells.count {
                  let cell = visibleCells[i]
                  if i <= upperIndexPaths.last!.row {
                     cell.identity()
                  } else {
                     cell.identity()
                  }
               }
               properties.delegate!.addNewObject(at: insertionIndexPath, upperIndexPaths: upperIndexPaths, lowerIndexPaths: lowerIndexPaths)
            }
            UIView.animate(withDuration: 0.2,
                           animations: {animation()},
                           completion: {_ in completion()}
            )
         } else {
            
            func animation() {
               let visibleCells = tableView.visibleCells
               for i in 0..<visibleCells.count {
                  let cell = visibleCells[i]
                  if i <= upperIndexPaths.last!.row {
                     cell.identity()
                  } else {
                     cell.identity()
                  }
               }
               dummyView!.infoLabel.text = ""
               dummyView!.identity()
            }
            func completion() {
               dummyView?.removeFromSuperview()
               
               let visibleCells = tableView.visibleCells
               for i in 0..<visibleCells.count {
                  let cell = visibleCells[i]
                  if i <= upperIndexPaths.last!.row {
                     cell.identity()
                  } else {
                     cell.identity()
                  }
               }
            }
            
            UIView.animate(withDuration: 0.2,
                           animations: {animation()},
                           completion: {_ in completion()}
            )
         }
      }
   }
}
