//
//  DefaultCells.swift
//  Components
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/02.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

open class DefaultHeader: DefaultCell {
   
   override open var datasourceItem: Any? {
      didSet {
         if datasourceItem == nil {
            label.text = "This is your default header"
         }
      }
   }
   
   override open func setupViews() {
      super.setupViews()
      label.text = "Header Cell"
      label.textAlignment = .center
   }
   
}

open class DefaultFooter: DefaultCell {
   
   override open var datasourceItem: Any? {
      didSet {
         if datasourceItem == nil {
            label.text = "This is your default footer"
         }
      }
   }
   
   override open func setupViews() {
      super.setupViews()
      label.text = "Footer Cell"
      label.textAlignment = .center
   }
   
}

open class DefaultCell: DatasourceCollectionViewCell {
   
   override open var datasourceItem: Any? {
      didSet {
         if let text = datasourceItem as? String {
            label.text = text
         } else {
            label.text = datasourceItem.debugDescription
         }
      }
   }
   
   let label: UILabel = {
      let label = UILabel.init()
      label.numberOfLines = 0
      label.font = UIFont.preferredFont(forTextStyle: .body)
      return label
   }()
   
   /// never ever ever use view instead of contentView
   override open func setupViews() {
      super.setupViews()
      contentView.addSubview(label)
      let metrics = ["width": UIApplication.shared.keyWindow!.frame.width - 20]
      Constraint.make("H:|-10-[v0(width)]-10-|", metrics: metrics, views: label)
      Constraint.make("V:|[v0(>=44)]|", views: label)
   }
}
