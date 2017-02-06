//
//  TableViewDatasourceCell.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

/// TableViewDatasourceCell is the base cell class for all cells used in TableViewDatasourceController and TableViewDatasource.  Using this cell, you can access the row's model object via datasourceItem.  You can also access the controller as well.
open class DatasourceTableViewCell: UITableViewCell {
   
   open var datasourceItem: Any?
   open weak var controller: DatasourceTableViewController? // instead of delegate
   
   open let separatorLineView: UIView = {
      let lineView = UIView()
      lineView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
      lineView.isHidden = true
      return lineView
   }()
   
   public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
   }
   /// Never Ever EVER use view instead of contentView
   open func setupViews() {
      contentView.addSubview(separatorLineView)
      Constraint.make("H:|[v0]|", views: separatorLineView)
      Constraint.make("V:[v0(0.5)]|", views: separatorLineView)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
