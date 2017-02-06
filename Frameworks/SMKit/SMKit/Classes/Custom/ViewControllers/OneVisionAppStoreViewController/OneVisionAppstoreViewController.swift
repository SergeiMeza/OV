//
//  OneVisionAppstoreViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

internal class OneVisionApptoreTableViewController: DatasourceTableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      datasource = OneVisionApptoreDatasource()
      
      navigationItem.title = OneVision.AboutMenu.Button.apps
      
      
      setupTableView()
   }
   
   private func setupTableView() {
      tableView.backgroundColor = .rgb(0xEEEEEE)
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .none
      tableView.showsVerticalScrollIndicator = false
   }
   
   private lazy var ovController: OneVisionController = { [unowned self] in
      let controller = OneVisionController()
      controller.setupProperties(viewController: self)
      return controller
   }()
   
   
   override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      if UITableViewAutomaticDimension <= 66 {
         return 66
      } else {
         logger.log(value: UITableViewAutomaticDimension)
         return UITableViewAutomaticDimension
      }
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if UITableViewAutomaticDimension <= 66 {
         return 66
      } else {
         logger.log(value: UITableViewAutomaticDimension)
         return UITableViewAutomaticDimension
      }
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      guard let app = datasource?.objects?[indexPath.row] as? (String,String,String) else {
         self.presentAlert(OneVision.ErrorMessages.tryAgain)
         tableView.deselectRow(at: indexPath, animated: false)
         return
      }
      
      ovController.showAppOnStore(app.2)
      tableView.deselectRow(at: indexPath, animated: false)
   }
}
