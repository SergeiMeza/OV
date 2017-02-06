//
//  TestViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit
import FontAwesomeKit

class TestViewController: ViewController {
   
   lazy var checkIcon : FAKIonIcons = FAKIonIcons.iosCheckmarkIcon(withSize: 30)
   lazy var closeIcon : FAKIonIcons = FAKIonIcons.iosCloseIcon(withSize: 30)
   lazy var composeIcon : FAKIonIcons = FAKIonIcons.iosComposeIcon(withSize: 30)
   lazy var clockIcon : FAKIonIcons = FAKIonIcons.iosClockIcon(withSize: 30)
   
   let greenColor = UIColor.init(r: 85, g: 213, b: 80)
   let redColor = UIColor.init(r: 213, g: 70, b: 70)
   let yellowColor = UIColor.init(r: 236, g: 223, b: 60)
   let brownColor = UIColor.init(r: 182, g: 127, b: 78)
   
   var removeCellBlock: ((UITableView, UITableViewCell) -> ())!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      datasource = MyDatasource()
      tableView.bg = .black
      
      setupIcons()
      
      removeCellBlock = { [unowned self] (tableView: UITableView, cell: UITableViewCell) -> Void in
         let indexPath = tableView.indexPath(for: cell)
         self.datasource?.objects?.remove(at: indexPath!.row)
         if let cell = cell as? SideViewTableViewCell {
            self.removeCell(cell, duration: 0.3, completion: nil)
         }
      }
   }
   
   func setupIcons() {
      checkIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
      closeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
      composeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
      clockIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
   }
   
   
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
      let size = CGSize(width: 30, height: 30)
      
      if let cell = cell as? SideViewTableViewCell {
         cell.firstLeftAction = TableViewCellAction(icon: checkIcon.image(with: size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
         
         cell.secondLeftAction = TableViewCellAction(icon: closeIcon.image(with: size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
         
         cell.firstRightAction = TableViewCellAction(icon: (composeIcon.image(with: size))!, color: yellowColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
         
         cell.secondRightAction = TableViewCellAction(icon: clockIcon.image(with: size), color: brownColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
      }
   }
}
