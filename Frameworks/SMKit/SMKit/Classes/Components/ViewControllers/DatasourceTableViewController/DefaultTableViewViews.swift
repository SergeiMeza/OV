//
//  TableViewDefaultCells.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

class DefaultTableViewCell: DatasourceTableViewCell {
   override var datasourceItem: Any? {
      didSet {
         if let text = datasourceItem as? String {
            textLabel?.text = text
            textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            textLabel?.numberOfLines = 0
         } else {
            textLabel?.text = datasourceItem.debugDescription
            textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            textLabel?.numberOfLines = 0
         }
      }
   }
}

class DefaultTableViewHeader: DatasourceTableViewHeaderFooterView {
   override var datasourceItem: Any? {
      didSet {
         if datasourceItem == nil {
            textLabel?.text = "This is your default header"
            textLabel?.textAlignment = .center
         }
      }
   }
}

class DefaultTableViewFooter: DatasourceTableViewHeaderFooterView {
   override var datasourceItem: Any? {
      didSet {
         if datasourceItem == nil {
            textLabel?.text = "This is your default footer"
            textLabel?.textAlignment = .center
         }
      }
   }
}
