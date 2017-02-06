//
//  ViewController.swift
//  TransparentNavigationController
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class ExampleDatasource: TableViewDatasource {
   override init() {
      super.init()
      objects = ["row1", "row2", "row3"]
   }
   
}

class ExampleViewController: DatasourceTableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Example"
      datasource = ExampleDatasource()
      
      // move the table to the top
//      automaticallyAdjustsScrollViewInsets = false
   }
}

