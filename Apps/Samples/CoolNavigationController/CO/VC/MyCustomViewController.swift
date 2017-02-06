//
//  CustomViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class TestingDatasource: TableViewDatasource {
   
   override init() {
      super.init()
      
      objects = ["ReviewAlert", "Test1", "test2"]
   }
}

class TestingTableViewController: DatasourceTableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      datasource = TestingDatasource()
      
      
   }
}

class MyCustomVC: FixHeaderViewController {
   
   override var prefersStatusBarHidden: Bool {
      return true
   }
   
   let headerView: View = {
      let v = StandardHeaderView()
      v.bg = .red
      return v
   }()
   
   let transparentSeparator: View = {
      let ts = View()
      ts.bg = .black
      ts.alpha = 0.3
      return ts
   }()
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup(fixedHeaderView: headerView, datasourceViewController: TestingTableViewController(), headerHeight: 44)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      (headerView as? StandardHeaderView)?.rightButton.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .black)
      
      view.addSubviews(transparentSeparator)
      transparentSeparator.addAnchors(toTop: headerView.bottomAnchor,
                                      toRight: v.rightAnchor,
                                      toLeft: v.leftAnchor,
                                      topConstant: -1, height: 8)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}
