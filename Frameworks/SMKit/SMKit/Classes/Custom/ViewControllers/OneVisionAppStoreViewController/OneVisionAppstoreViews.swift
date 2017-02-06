//
//  OneVisionAppstoreCell.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

internal class OneVisionApptoreCell: DatasourceTableViewCell {
   
   override var datasourceItem: Any? {
      didSet {
         guard let app = datasourceItem as? (appName:String, description: String, appID:String) else { return }
         iconView.image = UIImage.init(named: app.appID)
         appNameLabel.text = app.appName
         appDescriptionLabel.text = app.description
      }
   }
   
   let iconView: UIImageView = {
      let iv = UIImageView()
      iv.layer.cornerRadius = 12
      iv.layer.masksToBounds = true
      iv.contentMode = .scaleAspectFit
      return iv
   }()
   
   let appNameLabel: UILabel = {
      let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
      l.text = "appName"
      l.textColor = .black
      l.numberOfLines = 0
      return l
   }()
   
   let appDescriptionLabel: UILabel = {
      let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightUltraLight)
      l.text = "appDescription"
      l.textColor = .black
      l.numberOfLines = 0
      return l
   }()
   
//   let costView: UIImageView = {
//      let iv = UIImageView()
//      iv.contentMode = .scaleAspectFit
//      iv.isHidden = true
//      iv.alpha = 0
//      return iv
//   }()
   
   override func setupViews() {
      super.setupViews()
      
      addSubviews(iconView,appNameLabel,appDescriptionLabel)
      
      iconView.addAnchors(toTop: topAnchor,
                          toLeft: leftAnchor,
                          topConstant: 8,
                          leftConstant: 8,
                          width: 50,
                          height: 50)
      
      
      appNameLabel.addAnchors(toTop: iconView.topAnchor,
                              toRight: rightAnchor,
                              toLeft: iconView.rightAnchor,
                              rightConstant: 12,
                              leftConstant: 8)
      
      appDescriptionLabel.addAnchors(toTop: appNameLabel.bottomAnchor,
                                     toRight: appNameLabel.rightAnchor,
                                     toLeft: appNameLabel.leftAnchor,
                                     topConstant: 4)
   }
}
