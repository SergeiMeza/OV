//
//  ViewController.swift
//  TemplateApp4
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/24.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class MyDatasource: TableViewDatasource
{
   override init() {
      super.init()
      
      objects = ["1",
                 "2",
                 "3",
                 "4",
                 "5",
                 "6",
                 "7",
                 "8",
      ]
//                 "11",
//                 "12",
//                 "13",
//                 "14",
//                 "15",
//                 "16",
//                 "17",
//                 "18",
//                 "2",
//                 "3",
//                 "4",
//                 "5",
//                 "6",
//                 "7",
//                 "8",
//                 "11",
//                 "12",
//                 "13",
//                 "14",
//                 "15",
//                 "16",
//                 "17",
//                 "18",
//                 "2",
//                 "3",
//                 "4",
//                 "5",
//                 "6",
//                 "7",
//                 "8",
//                 "11",
//                 "12",
//                 "13",
//                 "14",
//                 "15",
//                 "16",
//                 "17",
//                 "18",
//                 "2",
//                 "3",
//                 "4",
//                 "5",
//                 "6",
//                 "7",
//                 "8",
//                 "11",
//                 "12",
//                 "13",
//                 "14",
//                 "15",
//                 "16",
//                 "17",
//                 "18",
//                 "2",
//                 "3",
//                 "4",
//                 "5",
//                 "6",
//                 "7",
//                 "8",
//                 "11",
//                 "12",
//                 "13",
//                 "14",
//                 "15",
//                 "16",
//                 "17",
//                 "18",
//      ]
   }
}

class ViewController: DatasourceTableViewController
{
   let rearrangeDriver = RearrangeDriver()
   var currentRearrangeIndexPath: IndexPath?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      datasource = MyDatasource()
      tableView.bg = .black
      
      rearrangeDriver.delegate = self
      rearrangeDriver.tableView = tableView
      
   }
   
   
   override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return false
   }
   
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if indexPath == currentRearrangeIndexPath {
         cell.isHidden = true
      } else {
         cell.isHidden = false
      }
   }
}

extension ViewController: RearrangeDelegate {

   func moveObjectAtCurrentRearrangeIndexPath(to indexPath: IndexPath) {
      guard let currentIndexPath = currentRearrangeIndexPath else {
         return
      }
      let object = datasource?.objects?[currentIndexPath.row]
      datasource?.objects?.remove(at: currentIndexPath.row)
      datasource?.objects?.insert(object ?? "0", at: indexPath.row)
   }
}
