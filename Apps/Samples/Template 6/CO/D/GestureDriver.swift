//
//  TableViewGesture.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/30.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

let tableViewCommitEditingRowDefaultLength: CGFloat = 80
let tableViewRowAnimationDuration: Double = 0.25
let snapshotTag = 10000


@objc enum GestureState: NSInteger {
   case none, dragging, pinching, panning, moving
}

// MARK: -
// MARK: Protocols

/// Conform to GestureAddingRowDelegate to enable the following features:
/// - drag down to add cell
/// - pinch to add cell
/// - (add cell at the end of tableview)
@objc protocol GestureAddingRowDelegate:GestureDelegate {
   
   func gesture(_ g: GestureDriver, needsAddRowAt ip: IndexPath)
   func gesture(_ g: GestureDriver, needsCommitRowAt ip: IndexPath)
   func gesture(_ g: GestureDriver, needsDiscardRowAt ip: IndexPath)
   
   @objc optional func gesture(_ g: GestureDriver, willCreateCellAt ip: IndexPath) -> IndexPath
   @objc optional func gesture(_ g: GestureDriver, heightForCommitingRowAt ip: IndexPath) -> CGFloat
}

/// Conform to GestureEditingRowDelegate to enable the following features:
/// - swipe to edit cell
@objc protocol GestureEditingRowDelegate:GestureDelegate {
   
   // panning (required)
   func gesture(_ g: GestureDriver, canEditRowAt ip: IndexPath) -> Bool
   func gesture(_ g: GestureDriver, didEnterEditingState state: CellEditingState, forRowAt ip: IndexPath)
   func gesture(_ g: GestureDriver, commitEditingState state: CellEditingState, forRowAt ip: IndexPath)
   
   @objc optional func gesture(_ g: GestureDriver, lengthForCommitingEditingRowAt ip: IndexPath) -> CGFloat
   @objc optional func gesture(_ g: GestureDriver, didChangeContentViewTranslation translation: CGPoint, forRowAt ip: IndexPath)
}

/// Conform to GestureMoveRowDelegate to enable the following features:
/// - long press to reorder cells
@objc protocol GestureMoveRowDelegate:GestureDelegate {
   
   func gesture(_ g: GestureDriver, canMoveRowAt ip: IndexPath) -> Bool
   func gesture(_ g: GestureDriver, needsCreatePlaceholderForRowAt ip: IndexPath)
   func gesture(_ g: GestureDriver, needsMoveRowAt sourceIP: IndexPath, toIndexPath destinationIP: IndexPath)
   func gesture(_ g: GestureDriver, needsReplacePlaceholderForRowAt ip: IndexPath)
}


@objc protocol GestureDelegate:class {
   
}


// MARK: -
// MARK: GestureDriver

class GestureDriver: NSObject, UITableViewDelegate, UIGestureRecognizerDelegate
{
   weak var delegate: GestureDelegate?
   weak var tableViewDelegate: UITableViewDelegate? // mmmm....
   
   weak var tableView: UITableView?
   
   var addingRowHeight: CGFloat = 0
   var addingIndexPath: IndexPath?
   var addingCellState: CellEditingState = .none
   
   var startPinchingUpperPoint: CGPoint? = nil
   
   var pinch: UIPinchGestureRecognizer? = nil
   var pan: UIPanGestureRecognizer? = nil
   var longPress: UILongPressGestureRecognizer? = nil
   
   var state: GestureState = .none
   
   var cellSnapshot: UIImage? = nil
   var scrollingRate: CGFloat = 0
   var movingTimer: Timer? = nil
   
   // MARK: Class Method
   
   static func gestureDriverWith(_ tableView: UITableView, delegate: GestureDelegate) -> GestureDriver {
      
      let driver = GestureDriver()
      driver.tableView = tableView
      driver.delegate = delegate
      driver.tableViewDelegate = tableView.delegate
      
      let pinch = UIPinchGestureRecognizer.init(target: driver, action: #selector(pinched))
      tableView.addGestureRecognizer(pinch)
      pinch.delegate = driver
      driver.pinch = pinch
      
      let pan = UIPanGestureRecognizer.init(target: driver, action: #selector(panned))
      tableView.addGestureRecognizer(pan)
      pan.delegate = driver
      driver.pan = pan
      
      let longPress = UILongPressGestureRecognizer.init(target: driver, action: #selector(longPressed))
      tableView.addGestureRecognizer(longPress)
      longPress.delegate = driver
      driver.longPress = longPress
      
      return driver
   }
   
   // MARK: UIGestureRecognizerDelegate
   
   func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      guard let tableView = tableView else {
         return false
      }
      
      if gestureRecognizer == pan {
         if !(delegate is GestureMoveRowDelegate) {
            return false
         }
         let pan = gestureRecognizer as! UIPanGestureRecognizer
         
         let point = pan.translation(in: tableView)
         let loc = pan.location(in: tableView)
         let indexPath = tableView.indexPathForRow(at: loc)
         
         // The pan gesture recognizer will fail the original scrollView scroll
         // gesture, we wants to ensure we are panning left/right to enable the
         // pan gesture.
         if fabs(point.y) > fabs(point.x) {
            return false
         } else if indexPath == nil {
            return false
         } else if let indexPath = indexPath {
            if let delegate = delegate as? GestureEditingRowDelegate {
               return delegate.gesture(self, canEditRowAt: indexPath)
            }
            return false
         }
      } else if gestureRecognizer == pinch {
         if !(delegate is GestureAddingRowDelegate) {
            return false
         }
         
         let loc1 = gestureRecognizer.location(ofTouch: 0, in: tableView)
         let loc2 = gestureRecognizer.location(ofTouch: 1, in: tableView)
         let rect = CGRect(origin: loc1, size: CGSize.init(width: loc2.x-loc1.x, height: loc2.y-loc2.x))
         
         if let ips = tableView.indexPathsForRows(in: rect) {
            if ips.count < 2 {
               return false
            }
            
            let firstIP = ips.first!
            let lastIP = ips.last!
            let midIndex = Int(Double((firstIP.row + lastIP.row))/2 + 0.5)
            let midIndexPath = IndexPath(row: midIndex, section: firstIP.section)
            
            if let delegate = delegate as? GestureAddingRowDelegate {
               addingIndexPath = (delegate.gesture?(self, willCreateCellAt: midIndexPath) != nil) ? delegate.gesture!(self, willCreateCellAt: midIndexPath) : midIndexPath
            } else {
               return false
            }
            if addingIndexPath == nil {
               return false
            }
         } else {
            return false
         }
      } else if gestureRecognizer == longPress {
         
         let loc = gestureRecognizer.location(in: tableView)
         
         if let delegate = delegate as? GestureMoveRowDelegate {
            if let ip = tableView.indexPathForRow(at: loc) {
               return delegate.gesture(self, canMoveRowAt: ip)
            }
         } else {
            return false
         }
         return false
      }
      return true
   }
   
   // MARK: UITableViewDelegate
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath == addingIndexPath && (state == .pinching ||  state == .dragging) {
         
         // While state is in pinching or dragging mode, we intercept the row height
         // For Moving state, we leave our real delegate to determine the actual height
         return max(1, addingRowHeight)
      }
      let height = tableViewDelegate?.tableView?(tableView, heightForRowAt: indexPath)
      let normalCellHeight = height != nil ? height! : tableView.rowHeight
      return normalCellHeight
   }
   
   // MARK: UIScrollViewDelegate
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if !(delegate is GestureAddingRowDelegate) {
         tableViewDelegate?.scrollViewDidScroll?(scrollView)
         return
      }
      
      // We try to create a new cell when the user tries to drag the content to and offset of negative value
      if scrollView.contentOffset.y < 0 {
         // Here we make sure we're not conflicting with the pinch event,
         // ! scrollView.isDecelerating is to detect if user is actually
         // touching on our scrollView, if not, we should assume the scrollView
         // needed not to be adding cell
         if addingIndexPath == nil && state == .none && !scrollView.isDecelerating {
            state = .dragging
            
            addingIndexPath = IndexPath(row: 0, section: 0)
            if let delegate = delegate as? GestureAddingRowDelegate {
               let ip = delegate.gesture?(self, willCreateCellAt: addingIndexPath!)
               addingIndexPath = ip != nil ? ip! : IndexPath(row: 0, section: 0)
            } else {
               logger.log(value: "")
            }
            
            if let tableView = tableView,
               let addingIndexPath = addingIndexPath {
              if let delegate = delegate as? GestureAddingRowDelegate {
               tableView.beginUpdates()
               delegate.gesture(self, needsAddRowAt: addingIndexPath)
               tableView.insertRows(at: [addingIndexPath], with: .none)
               addingRowHeight = fabs(scrollView.contentOffset.y)
               tableView.endUpdates()
              } else {
               logger.log(value: "")
               }
            }
         }
      }
      
      if addingIndexPath != nil && state == .dragging {
         addingRowHeight += scrollView.contentOffset.y * -1
         tableView?.reloadData()
         scrollView.contentOffset = .zero
      }
   }
   
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if !(delegate is GestureAddingRowDelegate) {
         tableViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
         return
      }
      
      if state == .dragging {
         state = .none
         commitOrDiscardCell()
      }
   }
}


// GestureMoveRow
extension GestureDriver {
   
   func longPressed(_ g: UILongPressGestureRecognizer) {
      
      guard let tableView = tableView, let delegate = delegate as? GestureMoveRowDelegate else {
         return
      }
      
      let loc = g.location(in: tableView)
      let ip = tableView.indexPathForRow(at: loc)
      
      if g.state == .began {
         state = .moving
         
         if let ip = ip, let cell = tableView.cellForRow(at: ip) {
            
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            let context = UIGraphicsGetCurrentContext()!
            cell.layer.render(in: context)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // We create an imageView for caching the cell snapshot here
            var snapshotView = tableView.viewWithTag(snapshotTag) as? UIImageView
            if snapshotView == nil {
               snapshotView = UIImageView(image: cellImage)
               snapshotView?.tag = snapshotTag
               tableView.addSubview(snapshotView!)
               let rect = tableView.rectForRow(at: ip)
               snapshotView?.frame = snapshotView!.bounds.offsetBy(dx: rect.origin.x, dy: rect.origin.y)
            }
            
            // Make a zoom in effect of the cell
            UIView.beginAnimations("zoomCell", context: nil)
            snapshotView?.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            snapshotView?.center = CGPoint.init(x: tableView.center.x, y: loc.y)
            UIView.commitAnimations()
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [ip], with: .none)
            tableView.insertRows(at: [ip], with: .none)
            
            delegate.gesture(self, needsCreatePlaceholderForRowAt: ip)
            addingIndexPath = ip
            
            tableView.endUpdates()
            
            
            // start timer to prepare for auto scrolling
            movingTimer = Timer.init(timeInterval: 1/8, target: self, selector: #selector(scrollTable), userInfo: nil, repeats: true)
            
            RunLoop.main.add(movingTimer!, forMode: .defaultRunLoopMode)
         } else if g.state == .ended {
            
            // While long press ends, we remove the snapshot imageView
            
            UIView.animate(withDuration: tableViewRowAnimationDuration, animations: { [unowned self, weak snapshotView = tableView.viewWithTag(snapshotTag)] in
               let rect = self.tableView?.rectForRow(at: self.addingIndexPath!)
               snapshotView?.transform = CGAffineTransform.identity
               snapshotView?.frame = snapshotView!.bounds.offsetBy(dx: rect!.origin.x, dy: rect!.origin.y)
               }, completion: { [unowned self, weak snapshotView = tableView.viewWithTag(snapshotTag)] (_) in
                  
                  snapshotView?.removeFromSuperview()
                  
                  self.tableView?.beginUpdates()
                  self.tableView?.deleteRows(at: [self.addingIndexPath!], with: .none)
                  self.tableView?.insertRows(at: [self.addingIndexPath!], with: .none)
                  
                  if let delegate = self.delegate as? GestureMoveRowDelegate {
                     delegate.gesture(self, needsReplacePlaceholderForRowAt: self.addingIndexPath!)
                  } else {
                     logger.log(value: "")
                  }
                  
                  self.tableView?.endUpdates()
                  
                  self.tableView?.reloadVisibleRowsExcept(self.addingIndexPath!)
                  
                  // Update state and clear instance variables
                  self.cellSnapshot = nil
                  self.addingIndexPath = nil
                  self.state = .none
            })
            
         } else if g.state == .changed {
            // While our finger moves, we also moves the snapshot imageView
            let snapshotView = tableView.viewWithTag(snapshotTag)
            snapshotView?.center = CGPoint.init(x: tableView.center.x, y: loc.y)
            
            let rect = tableView.bounds
            var location = longPress?.location(in: tableView)
            location?.y -= tableView.contentOffset.y // We needed to compensate actual contentOffset.y to get the relative y position of touch.
            
            updateAddingIndexPathForCurrentLocation()
            
            
            let bottomDropZoneHeight = tableView.bounds.height / 6
            let topDropZoneHeight = bottomDropZoneHeight
            let bottomDiff : CGFloat = location!.y - (rect.height - bottomDropZoneHeight)
            if bottomDiff > 0 {
               scrollingRate = bottomDiff / (bottomDropZoneHeight)
            } else if location!.y <= topDropZoneHeight {
               scrollingRate = -(topDropZoneHeight - max(location!.y, 0)) / bottomDropZoneHeight
            } else {
               scrollingRate = 0
            }
         }
      }
   }
   
   // Scroll tableview while touch point is on top or bottom part
   func scrollTable() {
      guard let longPress = longPress,
         let tableView = tableView,
         delegate is GestureMoveRowDelegate
         else {
            return
      }
      
      let loc = longPress.location(in: tableView)
      let currentOffset = tableView.contentOffset
      var newOffset = CGPoint.init(x: currentOffset.x, y: currentOffset.y + scrollingRate)
      if newOffset.y < 0 {
         newOffset.y = 0
      } else if tableView.contentSize.height < tableView.frame.height {
         newOffset = currentOffset
      } else if newOffset.y > tableView.contentSize.height - tableView.frame.height {
         newOffset.y = tableView.contentSize.height - tableView.frame.height
      } else {
         // MARK: More Code To Come
      }
      tableView.contentOffset = newOffset
      
      if loc.y >= 0 {
         let cellSnapshotView: UIImageView? = tableView.viewWithTag(snapshotTag) as? UIImageView
         cellSnapshotView?.center = CGPoint.init(x: tableView.center.x, y: loc.y)
      }
      
      updateAddingIndexPathForCurrentLocation()
   }
   
   
   
   func updateAddingIndexPathForCurrentLocation() {
      guard let tableView = tableView, let longPress = longPress, let delegate = delegate as? GestureMoveRowDelegate else {
         return
      }
      
      let loc = longPress.location(in: tableView)
      let indexPath = tableView.indexPathForRow(at: loc)
      
      if let indexPath = indexPath, let addingIndexPath = addingIndexPath, indexPath != addingIndexPath {
         tableView.beginUpdates()
         tableView.deleteRows(at: [addingIndexPath], with: .none)
         tableView.insertRows(at: [indexPath], with: .none)
         delegate.gesture(self, needsMoveRowAt: addingIndexPath, toIndexPath: indexPath)
         self.addingIndexPath = indexPath
         tableView.endUpdates()
      }
   }
}

// GestureAddingRow
extension GestureDriver {
   
   
   // MARK: Logic
   
   func commitOrDiscardCell() {
      guard let tableView = tableView,
         let addingIndexPath = addingIndexPath,
         let delegate = delegate as? GestureAddingRowDelegate
         else {
            return
      }
      
      if let cell = tableView.cellForRow(at: addingIndexPath) {
         
         tableView.beginUpdates()
         let commitingCellHeight = delegate.gesture?(self, heightForCommitingRowAt: addingIndexPath) ?? tableView.rowHeight
         
         if cell.frame.height >= commitingCellHeight {
            delegate.gesture(self, needsCommitRowAt: addingIndexPath)
         } else {
            delegate.gesture(self, needsDiscardRowAt: addingIndexPath)
            tableView.deleteRows(at: [addingIndexPath], with: .middle)
         }
         
         // reload other rows as well
         tableView.perform(#selector(tableView.reloadVisibleRowsExcept),
                           with: addingIndexPath,
                           afterDelay: tableViewRowAnimationDuration)
         
         self.addingIndexPath = nil
         tableView.endUpdates()
         
         // restore contentInset while touch ends
         UIView.beginAnimations("", context: nil)
         UIView.setAnimationBeginsFromCurrentState(true)
         UIView.setAnimationDuration(0.5)
         tableView.contentInset = .zero
         UIView.commitAnimations()
      }
      state = .none
   }
   
   func pinched(_ g: UIPinchGestureRecognizer) {
      
      guard let tableView = tableView, let delegate = delegate as? GestureAddingRowDelegate else {
         return
      }
      
      if g.state == .ended || g.numberOfTouches < 2 {
         if addingIndexPath != nil {
            commitOrDiscardCell()
         }
         return
      }
      
      let loc1 = g.location(ofTouch: 0, in: tableView)
      let loc2 = g.location(ofTouch: 1, in: tableView)
      let upperPoint = loc1.y < loc2.y ? loc1 : loc2
      
      let rect = CGRect.init(origin: loc1, size: .init(width: loc2.x - loc1.x, height: loc2.y - loc1.y))
      
      if g.state == .began {
         guard let addingIndexPath = addingIndexPath else {
            fatalError("LOG: self.addingIndexPath must not be nil, we should have set it in recognizerShouldBegin")
         }
         
         state = .pinching
         
         // Setting up properties for referencing later when touches changes
         startPinchingUpperPoint = upperPoint
         
         // Creating contentInset to fulfill the whole screen, so our tableview won't occasionaly
         // bounds back to the top while we don't have enough cells on the screen
         tableView.contentInset = .init(top: tableView.frame.height,
                                        left: 0,
                                        bottom: tableView.frame.height,
                                        right: 0)
         
         tableView.beginUpdates()
         delegate.gesture(self, needsAddRowAt: addingIndexPath)
         
         tableView.insertRows(at: [addingIndexPath], with: .middle)
         tableView.endUpdates()
         
      } else if g.state == .changed {
         
         let diffRowHeight = rect.height - rect.height/g.scale
         
         if addingRowHeight - diffRowHeight >= 1 || addingRowHeight - diffRowHeight <= -1 {
            addingRowHeight = diffRowHeight
            tableView.reloadData()
         }
         
         // Scrolls tableview according to the upper touch point to mimic a realistic
         // dragging gesture
         let newUpperPoint = upperPoint
         let diffOffsetY = startPinchingUpperPoint!.y - newUpperPoint.y
         let newOffset = CGPoint.init(x: tableView.contentOffset.x, y: tableView.contentOffset.y + diffOffsetY)
         tableView.setContentOffset(newOffset, animated: false)
      }
   }
}


// GestureEditingRowDelegate
extension GestureDriver {
   
   
   func panned(_ g: UIPanGestureRecognizer) {
      
      guard let tableView = tableView,
         let delegate = delegate as? GestureEditingRowDelegate
         else {
            return
      }
      
      if g.state == .began || g.state == .changed && g.numberOfTouches > 0 {
         
         // TODO: Should ask delegate before changing cell's content view
         
         let loc1 = g.location(ofTouch: 0, in: tableView)
         
         var indexPath = addingIndexPath
         
         if indexPath == nil {
            indexPath = tableView.indexPathForRow(at: loc1)
            self.addingIndexPath = indexPath
         }
         
         state = .panning
         
         if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
            
            let translation = g.translation(in: tableView)
            cell.contentView.frame = cell.contentView.bounds.offsetBy(dx: translation.x, dy: 0)
            
            delegate.gesture?(self, didChangeContentViewTranslation: translation, forRowAt: indexPath)
            
            let commitEditingLength: CGFloat = (delegate.gesture?(self, lengthForCommitingEditingRowAt: indexPath) != nil) ? delegate.gesture!(self, lengthForCommitingEditingRowAt: indexPath) : tableViewCommitEditingRowDefaultLength
            
            if fabs(translation.x) >= commitEditingLength {
               if addingCellState == .middle {
                  addingCellState = translation.x > 0 ? .right : .left
               }
            } else {
               if addingCellState != .middle {
                  addingCellState = .middle
               }
            }
            delegate.gesture(self, commitEditingState: addingCellState, forRowAt: indexPath)
         }
      } else if g.state == .ended {
         
         if let indexPath = addingIndexPath {
            addingIndexPath = nil
            
            if let cell = tableView.cellForRow(at: indexPath) {
               let translation = g.translation(in: tableView)
               
               let commitEditingLength: CGFloat = (delegate.gesture?(self, lengthForCommitingEditingRowAt: indexPath) != nil) ? delegate.gesture!(self, lengthForCommitingEditingRowAt: indexPath) : tableViewCommitEditingRowDefaultLength
               
               if fabs(translation.x) >= commitEditingLength {
                  delegate.gesture(self, commitEditingState: addingCellState, forRowAt: indexPath)
               } else {
                  UIView.beginAnimations("", context: nil)
                  cell.contentView.frame = cell.contentView.bounds
                  UIView.commitAnimations()
               }
            }
         }
         addingCellState = .middle
         state = .none
      }
   }
}


// MARK: -
// MARK: UITableView Extension

extension UITableView {
   
   func enableGestureDriverWithDelegate(_ delegate: GestureDelegate) -> GestureDriver {
      if !( delegate is GestureAddingRowDelegate) &&
         !( delegate is GestureEditingRowDelegate) &&
         !( delegate is GestureMoveRowDelegate) {
         fatalError("Delegate should at least conform to one of: \n    JTTableViewGestureAddingRowDelegate\n    JTTableViewGestureEditingRowDelegate\n    JTTableViewGestureMoveRowDelegate")
      }
      // check
      return GestureDriver.gestureDriverWith(self, delegate: delegate)
   }
   
   
   // MARK: Helper Methods
   
   func reloadVisibleRowsExcept(_ indexPath: IndexPath) {
      var visibleRows = self.indexPathsForVisibleRows
      if let index = visibleRows?.index(of: indexPath) {
         visibleRows?.remove(at: index)
      }
      if let visibleRows = visibleRows {
         reloadRows(at: visibleRows, with: .none)
      }
   }
}




























