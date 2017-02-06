//
//  ViewController.swift
//  TemplateApp3
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/10.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class MyDatasource: TableViewDatasource
{
   override init() {
      super.init()
      
      objects = [Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date()]
   }
}

class ViewController: DatasourceTableViewController
{
   lazy var pinchDriver: PinchGestureDriver = { [unowned self] in
      let driver = PinchGestureDriver()
      driver.vc = self
      driver.tableView = self.tableView
      return driver
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      datasource = MyDatasource()
      
      pinchDriver.isActive = true
   }
}

