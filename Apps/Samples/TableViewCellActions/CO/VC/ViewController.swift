//
//  ViewController.swift
//  TemplateApp5
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit


class ViewController: DatasourceTableViewController
{
   
   var edgeSlidingMargin: CGFloat = 0.0
   var cellReplacingBlock: ((UITableView, SideViewTableViewCell) -> (Void))? // delegate
   
   // MARK: Methods
   
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
      if let cell = cell as? DatasourceTableViewCell {
         cell.separatorLineView.bg = UIColor.init(rgb: 0xEEEEEE, alpha: 1)
         cell.separatorLineView.isHidden = false
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      datasource = MyDatasource()
      tableView.bg = .black
      
      cellReplacingBlock = { [unowned self] (tableView: UITableView, cell: SideViewTableViewCell) -> Void in
         self.replaceCell(cell, duration: 0.5, bounce: 0, completion: nil)
      }
   }
   
   override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return false
   }
}

extension ViewController {
   
   func removeCellAt(_ indexPath: IndexPath, duration: TimeInterval, completion:(() -> Void)?) {
      let cell = tableView.cellForRow(at: indexPath)! as! SideViewTableViewCell;
      removeCell(cell, indexPath: indexPath, duration: duration, completion: completion)
   }
   
   func removeCell(_ cell: SideViewTableViewCell, duration: TimeInterval, completion:(() -> Void)?) {
      let indexPath = tableView.indexPath(for: cell)!
      removeCell(cell, indexPath: indexPath, duration: duration, completion: completion)
   }
   
   private func removeCell(_ cell: SideViewTableViewCell, indexPath: IndexPath, duration: TimeInterval, completion: (()-> Void)?) {
      var duration = duration
      if (duration == 0) {
         duration = 0.3
      }
      let animation : UITableViewRowAnimation = cell.frame.originX > 0 ? .right : .left
      
      UIView.animate(withDuration: duration * cell.percentageOffsetFromEnd(), animations: {
         let x = cell.frame.width/2 + (cell.frame.originX > 0 ? cell.frame.width : -cell.frame.width)
         let y = cell.center.y
         cell.center = CGPoint(x: x, y: y)
      }, completion: { [unowned self] (finished) -> Void in
         UIView.animate(withDuration: duration, animations: {
            cell.leftSideView.alpha = 0
            cell.rightSideView.alpha = 0
         })
         
         self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animation, duration: duration) { () -> Void in
            cell.leftSideView.alpha = 1
            cell.rightSideView.alpha = 1
            cell.leftSideView.removeFromSuperview()
            cell.rightSideView.removeFromSuperview()
            completion?()
         }
      })
   }
   
   func replaceCell(_ cell: SideViewTableViewCell, duration: TimeInterval, bounce: (CGFloat), completion:(() -> Void)?) {
      var duration = duration, bounce = bounce
      if duration == 0 {
         duration = 0.25
      }
      bounce = fabs(bounce)
      
      UIView.animate(withDuration: duration * cell.percentageOffsetFromCenter(), animations: { () -> Void in
         let x = cell.frame.width/2 + (cell.frame.originX > 0 ? -bounce : bounce)
         let y = cell.center.y
         cell.center = CGPoint(x: x, y: y)
         cell.leftSideView.iconImageView.alpha = 0
         cell.rightSideView.iconImageView.alpha = 0
      }, completion: {(done) -> Void in
         UIView.animate(withDuration: duration/2, animations: { () -> Void in
            cell.center = CGPoint(x: cell.frame.size.width/2, y: cell.center.y)
         }, completion: {(done) -> Void in
            cell.leftSideView.removeFromSuperview()
            cell.rightSideView.removeFromSuperview()
            completion?()
         })
      })
   }
   
   func fullSwipeCell(_ cell: SideViewTableViewCell, duration: TimeInterval, completion:(() -> Void)?) {
      UIView.animate(withDuration: duration * cell.percentageOffsetFromCenter(), animations: { () -> Void in
         let x = cell.frame.width/2 + (cell.frame.originX > 0 ? cell.frame.width : -cell.frame.width)
         let y = cell.center.y
         cell.center = CGPoint(x: x, y: y)
      }, completion: {(done) -> Void in
         completion?()
      })
   }
   
   fileprivate func deleteRowsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation, duration: TimeInterval, completion:@escaping () -> Void) {
      CATransaction.begin()
      CATransaction.setCompletionBlock(completion)
      UIView.animate(withDuration: duration, animations: {
         self.tableView.deleteRows(at: indexPaths, with: animation)
      })
      CATransaction.commit()
   }
}

// MARK: -
// MARK: Datasource

class MyDatasource: TableViewDatasource
{
   override func cellClasses() -> [DatasourceTableViewCell.Type] {
      return [SideViewTableViewCell.self]
   }
   
   override init() {
      super.init()
      objects = ["1", "2", "3","4", "5", "6","7", "8", "9","10", "11", "12"]
   }
}
