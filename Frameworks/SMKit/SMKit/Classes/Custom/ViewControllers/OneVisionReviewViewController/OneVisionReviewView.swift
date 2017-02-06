//
//  OneVisionReviewView.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

internal class OneVisionReviewView : UIView {
   
   lazy var closeButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .black)
      b.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
      return b
      }()
   
   lazy var stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .center
      sv.distribution = .fillProportionally
      if UIDevice.current.userInterfaceIdiom == .phone {
         sv.spacing = 16
      } else {
         sv.spacing = 40
      }
      return sv
   }()
   
   lazy var label: UILabel = { [unowned self] in
      let l = UILabel.init()
      l.text = OneVision.ReviewMenu.ask
      l.textColor = UIColor._black
      l.textAlignment = .center
      l.numberOfLines = 0
      return l
      }()
   
   lazy var imageView: UIImageView = {
      let iv = UIImageView()
      iv.image = UIImage.init(named: "stars")
      iv.contentMode = .scaleAspectFit
      return iv
   }()
   
   lazy var buttonsStackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .fill
      sv.distribution = .fillEqually
      if UIDevice.current.userInterfaceIdiom == .phone {
         sv.spacing = 8
      } else {
         sv.spacing = 16
      }
      return sv
   }()
   
   lazy var reviewButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.ReviewMenu.go, for: .normal)
      b.backgroundColor = ._lightGray
      return b
      }()
   
   lazy var laterButton: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = ._black
      b.setTitle(OneVision.ReviewMenu.later, for: .normal)
      b.backgroundColor = ._lightGray
      return b
      }()
   
   var constraint: NSLayoutConstraint!
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubviews(closeButton, stackview, buttonsStackview)
      
      stackview.addArrangedSubviews(label, imageView)
      buttonsStackview.addArrangedSubviews(reviewButton, laterButton)
      
      setupConstraints()
      updateViewLayouts()
   }
   
   
   private func setupConstraints() {
      if UIDevice.current.userInterfaceIdiom == .phone { // iPhone
         
         Constraint.make("H:[v0]|", views: closeButton)
         Constraint.make("V:|[v0]", views: closeButton)
         
         imageView.scaleBy(0.8)
         
         Constraint.make(stackview, .centerX, self, .centerX, 1, 0)
         Constraint.make(stackview, .centerY, superView: .centerY, 1, -44-5)
         Constraint.make("H:|-16-[v0]-16-|", views: stackview)
         
         Constraint.make(buttonsStackview, .centerX, self, .centerX, 1, 0)
         Constraint.make(buttonsStackview, .bottom, superView: .bottom, 1, -height/40)
         Constraint.make(buttonsStackview, .left, buttonsStackview.superview, .left, 1, self.width/30)
         Constraint.make(buttonsStackview, .right, buttonsStackview.superview, .right, 1, -self.width/30)
         
         constraint = Constraint.init(item: reviewButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
         
      } else { // iPad
         
         Constraint.make("H:[v0]|", views: closeButton)
         Constraint.make("V:|[v0]", views: closeButton)
         
         imageView.scaleBy(1.2)
         
         Constraint.make(stackview, .centerX, self, .centerX, 1, 0)
         Constraint.make(stackview, .centerY, superView: .centerY, 1, -80-5)
         Constraint.make("H:|-16-[v0]-16-|", views: stackview)
         
         Constraint.make(buttonsStackview, .centerX, self, .centerX, 1, 0)
         Constraint.make(buttonsStackview, .bottom, superView: .bottom, 1, -height/40)
         Constraint.make(buttonsStackview, .left, buttonsStackview.superview, .left, 1, self.width/30)
         Constraint.make(buttonsStackview, .right, buttonsStackview.superview, .right, 1, -self.width/30)
         
         constraint = Constraint.init(item: reviewButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
         
      }
      reviewButton.translatesAutoresizingMaskIntoConstraints = false
      constraint.isActive = true
      layoutIfNeeded()
   }
   
   func updateViewLayouts() {
      if UIDevice.current.userInterfaceIdiom == .phone {
         if height > width {
            label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
            reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
            laterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
         } else {
            label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
            laterButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
         }
      } else {
         if height > width {
            label.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightLight)
            reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)
            laterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)
         } else {
            label.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightLight)
            reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
            laterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
         }
         
      }
   }   
}
