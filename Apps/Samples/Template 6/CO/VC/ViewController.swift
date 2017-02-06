//
//  ViewController.swift
//  Template 6
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/30.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit


struct InteractionText {
   static let addingCell = "Continue..."
   static let doneCell = "Done"
   static let dummyCell = "Dummy"
   static let addedCell = "Added!"
}

// MARK: -

class Datasource: TableViewDatasource {
   
   
   override func cellClasses() -> [DatasourceTableViewCell.Type] {
      return [PullDownCell.self, TransformableCell.self]
   }
   
   override func cellClass(at indexPath: IndexPath) -> DatasourceTableViewCell.Type? {
      if indexPath.row == 0 {
         return PullDownCell.self
      } else {
         return TransformableCell.self
      }
   }
   
   override init() {
      super.init()
      objects = ["Swipe to the right to complete",
                 "Swipe to the left to delete",
                 "Drag down to create a new cell",
                 "Pinch to rows apart to create cell",
                 "Long hold to start reorder cell",
                 ""]
   }
}

// MARK: -

class ViewController: DatasourceTableViewController
{
   var gestureDriver: GestureDriver!
   var grabbedObject: AnyObject?
   
   let commitingCreateCellHeight: CGFloat = 60
   let normalCellFinishingHeight: CGFloat = 60
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      datasource = Datasource()
      
      setupTableView()
      
      // Setup your tableView.delegate and tableView.datasource,
      // then enable gesture recognition in one line.
      gestureDriver = tableView.enableGestureDriverWithDelegate(self)
      
   }
}

// MARK: -

extension ViewController {
   
   func setupTableView() {
      tableView.backgroundColor = .black
   }
   
   func moveRowToBottomFor(_ ip: IndexPath) {
      tableView.beginUpdates()
      
      let object = datasource?.objects?[ip.row]
      datasource?.objects?.remove(at: ip.row)
      datasource?.objects?.append(object ?? "nil")
      let lastIP = IndexPath(row: datasource!.objects!.count - 1, section: 0)
      tableView.moveRow(at: ip, to: lastIP)
      tableView.endUpdates()
      
      tableView.perform(#selector(tableView.reloadVisibleRowsExcept(_:)), with: lastIP, afterDelay: tableViewRowAnimationDuration)
   }
}


// MARK: - GestureAddingRowDelegate

extension ViewController: GestureAddingRowDelegate
{
   func gesture(_ g: GestureDriver, needsAddRowAt ip: IndexPath) {
      datasource?.objects?.insert(InteractionText.addingCell, at: ip.row)
   }
   
   func gesture(_ g: GestureDriver, needsCommitRowAt ip: IndexPath) {
      datasource?.objects?[ip.row] = "Added!"
      
      if let cell = gestureDriver.tableView?.cellForRow(at: ip) as? TransformableCell {
         
         let isFirstCell = ip.section == 0 && ip.row == 0
         if isFirstCell && cell.frame.height > commitingCreateCellHeight * 2 {
            datasource?.objects?.remove(at: ip.row)
            tableView.deleteRows(at: [ip], with: .middle)
            // return to list
         } else {
            cell.finishedHeight = normalCellFinishingHeight
            cell.imageView?.image = nil
            cell.textLabel?.text = "Just Added!"
         }
      }
   }
   
   func gesture(_ g: GestureDriver, needsDiscardRowAt ip: IndexPath) {
      datasource?.objects?.remove(at: ip.row)
   }
   
}

// MARK: -
// MARK: GestureMoveRowDelegate

extension ViewController: GestureMoveRowDelegate {
   
   func gesture(_ g: GestureDriver, canMoveRowAt ip: IndexPath) -> Bool {
      return true
   }
   
   func gesture(_ g: GestureDriver, needsCreatePlaceholderForRowAt ip: IndexPath) {
      grabbedObject = datasource?.objects?[ip.row] as AnyObject?
      datasource?.objects?[ip.row] = InteractionText.dummyCell
   }
   
   func gesture(_ g: GestureDriver, needsMoveRowAt sourceIP: IndexPath, toIndexPath destinationIP: IndexPath) {
      let obj = datasource?.objects?[sourceIP.row]
      datasource?.objects?.remove(at: sourceIP.row)
      datasource?.objects?.insert(obj ?? "nil", at: destinationIP.row)
   }
   
   func gesture(_ g: GestureDriver, needsReplacePlaceholderForRowAt ip: IndexPath) {
      datasource?.objects?[ip.row] = grabbedObject as! String
      grabbedObject = nil
   }
}

// MARK: -
// MARK: GestureEditingRowDelegate

extension ViewController: GestureEditingRowDelegate {
   
   func gesture(_ g: GestureDriver, didEnterEditingState state: CellEditingState, forRowAt ip: IndexPath) {
      
      guard let cell = self.tableView.cellForRow(at: ip) else { return }
      
      var bgc: UIColor!
      switch state {
      case .middle:
         let hueOffset: CGFloat = 0.12 * CGFloat(ip.row) / CGFloat(self.tableView(tableView, numberOfRowsInSection: ip.section))
         bgc = UIColor.red.colorWithHueOffset(hueOffset)
      case .right:
         bgc = .green
      case .left:
         bgc = .darkGray
      case .none:
         break
      }
      
      cell.contentView.backgroundColor = bgc
      if let cell = cell as? TransformableCell {
         cell.tintColor = bgc
      }
   }
   
   // This is needed to be implemented to let our delegate choose whether the panning gesture should work
   func gesture(_ g: GestureDriver, canEditRowAt ip: IndexPath) -> Bool {
      return true
   }
   
   
   func gesture(_ g: GestureDriver, commitEditingState state: CellEditingState, forRowAt ip: IndexPath) {
      let myTableView = g.tableView
      
      var rowToBeMovedToBottom: IndexPath?
      
      myTableView?.beginUpdates()
      if state == .left {
         // An example to discard the cell at JTTableViewCellEditingStateLeft
         datasource?.objects?.remove(at: ip.row)
         myTableView?.deleteRows(at: [ip], with: .left)
      } else if state == .right {
         // An example to retain the cell at commiting at JTTableViewCellEditingStateRight
         datasource?.objects?[ip.row] = InteractionText.doneCell
         myTableView?.reloadRows(at: [ip], with: .left)
         rowToBeMovedToBottom = ip
      } else {
         // JTTableViewCellEditingStateMiddle shouldn't really happen in
         // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
         //         fatalError()
         print("fatalError")
      }
      myTableView?.endUpdates()
      
      myTableView?.perform(#selector(myTableView!.reloadVisibleRowsExcept(_:)), with: ip, afterDelay: tableViewRowAnimationDuration)
      
      if let rowToBeMovedToBottom = rowToBeMovedToBottom {
         perform(#selector(self.moveRowToBottomFor(_:)), with: rowToBeMovedToBottom, afterDelay: tableViewRowAnimationDuration * 2)
      }
   }
}

// MARK: -

extension ViewController {
   
   
}






















