//
//  TestViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class TestViewController: SMBaseTableViewController {
   
   let backgroundView: UIView = {
      let v = UIView()
      let iv = UIImageView()
      v.addSubview(iv)
      iv.fillSuperview()
      iv.image = #imageLiteral(resourceName: "ranking_large")
      iv.contentMode = .center
      return v
   }()
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      logger.log(value: "Presenting TestViewController")
      
      setupProperties(data)
      setupProperties(tableviewTitle: "COLORS", myCellClass: SMCustomTableViewCell02.self)
      
      _headerView.leftButton.isHidden = true
      _headerView.rightButton.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .rgb(0x1F1F1F))
      _tableView.backgroundView = backgroundView
      
      Constraint.make(_headerView.rightButton.imageView!, .width, _headerView.rightButton.imageView!, .height, 1, 0)
      Constraint.make(_headerView.rightButton.imageView!, .width, .equal, 25)
   }
   
   override func setupCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
      if let cell = cell as? SMCustomTableViewCell02 {
         cell.titleLabel.textColor = .black
      }
   }
}
