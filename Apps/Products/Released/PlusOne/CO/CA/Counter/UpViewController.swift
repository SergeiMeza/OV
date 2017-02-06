//
//  UpViewController.swift
//  +1 Counter
//
//  Created by Jeany Meza Rodriguez on 2016/09/29.
//  Copyright © 2016 Jeany Meza Rodriguez. All rights reserved.
//

import SMKit

var myFont: String { return Theme.Font.myAppFont }

class UpViewController: UIViewController
{
   
   lazy var counterDriver: CounterDriver = { [unowned self] in
      let cd = CounterDriver()
      cd.upVC = self
      return cd
   }()
   
   
   let stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.distribution = .fill
      sv.alignment = .fill
      return sv
   }()
   
   lazy var label: UILabel = { [unowned self] in
      let l = UILabel()
      l.textAlignment = .center
      l.textColor = .white
      l.numberOfLines = 0
      l.font = UIFont.init(name: myFont, size: self.view.height/3)
      return l
   }()
   
   lazy var textfield: UITextField = { [unowned self] in
      let tf = UITextField.init()
      tf.textAlignment = .center
      tf.textColor = UIColor.init(white: 1, alpha: 0.5)
      tf.borderStyle = .none
      tf.font = UIFont.init(name: myFont, size: self.view.height/20)
      return tf
   }()
   
   lazy var button: UIButton = { [unowned self] in
      let b = UIButton.init(type: .custom)
      b.setTitle("0", for: .normal)
      b.titleLabel?.font = UIFont.init(name: myFont, size: self.view.height/20)
      b.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
      return b
   }()
   
}

extension UpViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   fileprivate func setupViews() {
      view.bg = .black
      
      view.addSubviews(stackview, button)
      stackview.addArrangedSubviews(label, textfield)
      
      Constraint.make(stackview, .centerX, view, .centerX, 1, 0)
      Constraint.make(stackview, .centerY, view, .centerY, 1, 0)
      Constraint.make("H:|[v0]|", views: stackview)
      
      Constraint.make(button, .right, button.superview, .right, 1, -view.width/25)
      Constraint.make(button, .top, button.superview, .top, 1, view.height/35)
   }
}


extension UpViewController {
   
   override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      
      func updateViews() {
         label.font = UIFont.init(name: myFont, size: size.height/3)
         textfield.font = UIFont.init(name: myFont, size: size.height/20)
         button.titleLabel?.font = UIFont.init(name: myFont, size: size.height/20)
      }
      
      coordinator.animate(alongsideTransition: { _ in updateViews() },
                          completion: { _ in updateViews() } )
   }
}
