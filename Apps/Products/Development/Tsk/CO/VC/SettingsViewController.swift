//
//  SettingsViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class TDS: TableViewDatasource {
   
   override init() {
      super.init()
      objects = ["line 1", "line 2", "line 33333333333333333333444444444444444444455555555555 55555"]
   }
}

class TDsTVC: DatasourceTableViewController {
   
   override init() {
      super.init()
      datasource = TDS() // if added after, automatic dimensions doesn't work xD
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   
   override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   
}

class THV: StandardHeaderView {
   
}

class TVC: FixHeaderViewController {
   
   var headerView: THV = {
      let hv = THV(frame: .zero)
      hv.bg = .black
      return hv
   }()
   var tvc: TDsTVC = {
      let tvc = TDsTVC()
      return tvc
   }()
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup(fixedHeaderView: headerView, datasourceViewController: tvc)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
}
