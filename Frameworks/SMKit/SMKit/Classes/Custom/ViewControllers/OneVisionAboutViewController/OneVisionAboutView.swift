//
//  OneVisionAboutView.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

internal class OneVisionAboutView: UIView {
   
   fileprivate var constraint: Constraint!
   
   lazy var closeButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .black)
      b.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
      return b
      }()
   
   lazy var appStackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .center
      sv.distribution = .fillProportionally
      sv.spacing = 4
      sv.alpha = 0
      sv.isUserInteractionEnabled = false
      return sv
   }()
   
   lazy var appNameLabel: UILabel = { [unowned self] in
      let l = UILabel.init()
      l.text = "\(OneVision.App.appName)"
      l.textColor = UIColor._black
      l.font = UIFont.init(name: Theme.Font.myAppFont, size: 28)
      l.textAlignment = .center
      l.numberOfLines = 0
      return l
      }()
   
   lazy var appVersionLabel: UILabel = { [unowned self] in
      let l = UILabel.init()
      l.text = "VERSION \(OneVision.App.version)"
      l.textColor = UIColor._black
      l.textAlignment = .center
      l.numberOfLines = 0
      return l
      }()
   
   lazy var appDescriptionLabel: UILabel = { [unowned self] in
      let l = UILabel.init()
      l.text = OneVision.AboutMenu.description
      l.textColor = UIColor._black
      l.textAlignment = .center
      l.alpha = 0
      l.isUserInteractionEnabled = false
      l.numberOfLines = 0
      return l
      }()
   
   lazy var logoButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .custom)
      b.setImage(UIImage.init(named: "logo-fill"), for: .normal)
      return b
      }()
   
   lazy var stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .fill
      sv.distribution = .fillEqually
      sv.spacing = 4
      return sv
   }()
   
   lazy var subStackview01: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .fill
      sv.distribution = .fillEqually
      sv.spacing = 4
      return sv
   }()
   
   lazy var subStackview02: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .fill
      sv.distribution = .fillEqually
      sv.spacing = 4
      return sv
   }()
   
   
   lazy var appsButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.AboutMenu.Button.apps, for: .normal)
      
      b.backgroundColor = ._lightGray
      return b
      }()
   
   lazy var reviewButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.AboutMenu.Button.review, for: .normal)
      b.titleLabel?.font = UIFont.systemFont(ofSize: self.height/40, weight: UIFontWeightLight)
      b.backgroundColor = ._lightGray
      return b
      }()
   
   lazy var followButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.AboutMenu.Button.follow, for: .normal)
      b.titleLabel?.font = UIFont.systemFont(ofSize: self.height/40, weight: UIFontWeightLight)
      b.backgroundColor = ._lightGray
      return b
      }()
   
   lazy var newsletterButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.AboutMenu.Button.newsletter, for: .normal)
      b.titleLabel?.font = UIFont.systemFont(ofSize: self.height/40, weight: UIFontWeightLight)
      b.backgroundColor = ._lightGray
      return b
      }()
   
   lazy var contactButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.AboutMenu.Button.contact, for: .normal)
      b.titleLabel?.font = UIFont.systemFont(ofSize: self.height/40, weight: UIFontWeightLight)
      b.backgroundColor = ._lightGray
      return b
      }()
   
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubviews(closeButton, appStackview, appDescriptionLabel, logoButton, stackview)
      appStackview.addArrangedSubviews(appNameLabel, appVersionLabel)
      stackview.addArrangedSubviews(subStackview01, subStackview02)
      subStackview01.addArrangedSubviews(appsButton, followButton)
      subStackview02.addArrangedSubviews(newsletterButton, contactButton)
      setupConstraints()
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   open func setupConstraints() {
      
      Constraint.make("H:[v0]|", views: closeButton)
      Constraint.make("V:|[v0]", views: closeButton)
      
      appStackview.anchorCenterXToSuperview()
      appStackview.addAnchors(toTop: topAnchor,
                              topConstant: 64 + 20)

      
      Constraint.make(appDescriptionLabel, .centerX, self, .centerX, 1, 0)
      Constraint.make(appDescriptionLabel, .width, self, .width, 0.9, 0)
      Constraint.make(appDescriptionLabel, .centerY, self, .centerY, 0.5, 0)
      
      Constraint.center(logoButton, mX: 1, mY: 0.95, cX: 0, cY: 0)
      
      Constraint.make(stackview, .centerX, self, .centerX, 1, 0)
      Constraint.make(stackview, .bottom, stackview.superview, .bottom, 1, -self.height/40)
      Constraint.make(stackview, .left, stackview.superview, .left, 1, self.width/30)
      Constraint.make(stackview, .right, stackview.superview, .right, 1, -self.width/30)
      
      if UIDevice.current.userInterfaceIdiom == .phone {
         constraint = Constraint.init(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
      } else {
         constraint = Constraint.init(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
      }
      
      contactButton.translatesAutoresizingMaskIntoConstraints = false
      constraint.isActive = true
      layoutIfNeeded()
   }
   
   func updateSubviews() {
      if UIDevice.current.userInterfaceIdiom == .phone {
         
         appsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight) // 14 : 25
         followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight) // 14 : 25
         newsletterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight) // 14 : 25
         contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight) // 14 : 25
         
         
         if height > width {
            appNameLabel.font = UIFont.init(name: Theme.Font.myAppFont, size: 28)
            appVersionLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightUltraLight)
            appDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight) // 14 : 25
            
            logoButton.identity()
            stackview.axis = .vertical
         } else {
            appNameLabel.font = UIFont.init(name: Theme.Font.myAppFont, size: 22) // 22 : 40
            appVersionLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightUltraLight)
            appDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight) // 14 : 25
            
            logoButton.scaleBy(0.8)
            stackview.axis = .horizontal
         }
      } else {
         
         appsButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight) // 14 : 25
         followButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight) // 14 : 25
         newsletterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight) // 14 : 25
         contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight) // 14 : 25
         
         if height > width {
            appNameLabel.font = UIFont.init(name: Theme.Font.myAppFont, size: 50)
            appVersionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightUltraLight)
            appDescriptionLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightUltraLight) // 14 : 25
            
            stackview.axis = .vertical
         } else {
            appNameLabel.font = UIFont.init(name: Theme.Font.myAppFont, size: 50)
            appVersionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightUltraLight)
            appDescriptionLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightUltraLight) // 14 : 25
            
            stackview.axis = .horizontal
         }
      }
   }
}
