//
//  DefaultCells.swift
//  Components
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/02.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

class DefaultHeader: DefaultCell {
   
   override var datasourceItem: Any? {
      didSet {
         if datasourceItem == nil {
            label.text = "This is your default header"
         }
      }
   }
   
   override func setupViews() {
      super.setupViews()
      label.text = "Header Cell"
      label.textAlignment = .center
   }
   
}

class DefaultFooter: DefaultCell {
   
   override var datasourceItem: Any? {
      didSet {
         if datasourceItem == nil {
            label.text = "This is your default footer"
         }
      }
   }
   
   override func setupViews() {
      super.setupViews()
      label.text = "Footer Cell"
      label.textAlignment = .center
   }
   
}

class DefaultCell: DatasourceCollectionViewCell {
   
   override var datasourceItem: Any? {
      didSet {
         if let text = datasourceItem as? String {
            label.text = text
         } else {
            label.text = datasourceItem.debugDescription
         }
      }
   }
   
   let label = UILabel()
   
   
   /// never ever ever use view instead of contentView
   override func setupViews() {
      super.setupViews()
      contentView.addSubview(label)
      Constraint.make("H:|-10-[v0]-10-|", views: label)
      Constraint.make("V:|[v0]|", views: label)
   }
}
