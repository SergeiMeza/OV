//
//  TableView.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

/// DatasourceTableViewController is simply a UITableViewController that allows you to quickly create list views. In order to render out items in your list, simply provide it with a Datasource object.
open class DatasourceTableViewController: UITableViewController {
 
   open let activityIndicatorView: UIActivityIndicatorView = {
      let aiv = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
      aiv.hidesWhenStopped = true
      aiv.color = .black
      return aiv
   }()
   
   open var datasource: TableViewDatasource? {
      didSet {
         if let cellClasses = datasource?.cellClasses() {
            for cellClass in cellClasses {
               tableView.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
            }
         }
         
         if let headerClasses = datasource?.headerClasses() {
            for headerClass in headerClasses {
               tableView.register(headerClass, forHeaderFooterViewReuseIdentifier: NSStringFromClass(headerClass))
            }
         }
         
         if let footerClasses = datasource?.footerClasses() {
            for footerClass in footerClasses {
               tableView.register(footerClass, forHeaderFooterViewReuseIdentifier: NSStringFromClass(footerClass))
            }
         }
         tableView.reloadData()
      }
   }
   
   public init() {
      super.init(style: .plain)
   }
   
   let defaultCellId  = "meza_defaultCellId"
   let defaultFooterId = "meza_defaultFooterId"
   let defaultHeaderId = "meza_defaultHeaderId"
   
   open override func viewDidLoad() {
      super.viewDidLoad()
      
      view.addSubview(activityIndicatorView)
      Constraint.center(activityIndicatorView)
      
      setupTableView()
   }
   
   fileprivate func setupTableView() {
      
      tableView.backgroundColor = .rgb(0xEEEEEE)
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .none
      
      tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: defaultCellId)
      tableView.register(DefaultTableViewHeader.self, forHeaderFooterViewReuseIdentifier: defaultHeaderId)
      tableView.register(DefaultTableViewFooter.self, forHeaderFooterViewReuseIdentifier: defaultFooterId)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   open override func numberOfSections(in tableView: UITableView) -> Int {
      return datasource?.numberOfSections() ?? 0
   }
   
   open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return datasource?.numberOfRows(in: section) ?? 0
   }
   
   /// Need to override this otherwise size doesn't get called (really)??
   open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   
   open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell: DatasourceTableViewCell
      
      if let cls = datasource?.cellClass(at: indexPath) {
         cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceTableViewCell
      } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
         let cls = cellClasses[indexPath.section]
         cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceTableViewCell
      } else if let cls = datasource?.cellClasses().first {
         cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceTableViewCell
      } else {
         cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath) as! DatasourceTableViewCell
      }
      
      cell.controller = self
      cell.datasourceItem = datasource?.item(indexPath)
      cell.textLabel?.numberOfLines = 0
      return cell
   }
   
   open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let reusableView: DatasourceTableViewHeaderFooterView
      
      if let classes = datasource?.headerClasses(), classes.count > section {
         reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(classes[section])) as! DatasourceTableViewHeaderFooterView
      } else if let cls = datasource?.headerClasses()?.first {
         reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(cls)) as! DatasourceTableViewHeaderFooterView
      } else {
         reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultHeaderId) as! DatasourceTableViewHeaderFooterView
      }
      
      reusableView.datasourceItem = datasource?.headerItem(section)
      return reusableView
   }
   
   open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      let reusableView: DatasourceTableViewHeaderFooterView
      
      if let classes = datasource?.footerClasses(), classes.count > section {
         reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(classes[section])) as! DatasourceTableViewHeaderFooterView
      } else if let cls = datasource?.footerClasses()?.first {
         reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(cls)) as! DatasourceTableViewHeaderFooterView
      } else {
         reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: defaultHeaderId) as! DatasourceTableViewHeaderFooterView
      }
      
      reusableView.datasourceItem = datasource?.footerItem(section)
      return reusableView
   }
   
   open func getRefreshControl() -> UIRefreshControl {
      let rc = UIRefreshControl()
      rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
      return rc
   }
   
   open func handleRefresh() {
      
   }
}
