

import SMKit

var myTextFont : String { return Theme.Font.myTextFont }

class ShopViewController: UIViewController {
   
   var constraint: Constraint!
   var constraint2: Constraint!
   var constraint3: Constraint!
   
   lazy var stackview: UIStackView = { [unowned self] in
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .center
      sv.distribution = .fillProportionally
      sv.spacing = (self.view.height/40 > 16) ? self.view.height / 40 : 16
      return sv
   }()
   
   lazy var label: UILabel = { [unowned self] in
      let l = UILabel()
      l.textAlignment = .center
      l.textColor = .black
      l.numberOfLines = 0
      l.text = moreThingsToCountString
      l.font = UIFont.init(name: myTextFont, size: self.view.height/28)
      return l
   }()
   
   let imageView: UIImageView = {
      let image = #imageLiteral(resourceName: "countersAsset")
      let iv = UIImageView.init(image: image)
      iv.contentMode = .scaleAspectFit
      iv.isUserInteractionEnabled = false
      iv.clipsToBounds = false
      return iv
   }()
   
   lazy var button: UIButton = { [unowned self] in
      let b = UIButton.init(type: .system)
      b.tintColor = .white
      b.setTitle(unlimitedCountersTitle, for: .normal)
      b.titleLabel?.font = UIFont.init(name: myTextFont, size: self.view.height/35)
      b.setTitleColor(.white, for: .normal)
      b.bg = ._darkGray
      return b
   }()
}

extension ShopViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   fileprivate func setupViews() {
      view.backgroundColor = ._gray2

      view.addSubviews(stackview)
      stackview.addArrangedSubviews(label, imageView, button)
      
      constraint2 = Constraint.init(item: stackview, attribute: .width, relatedBy: .equal, toItem: stackview.superview, attribute: .width, multiplier: 1, constant: 0)
      stackview.translatesAutoresizingMaskIntoConstraints = false
      constraint2.isActive = true
      
      Constraint.make(stackview, .centerX, stackview.superview, .centerX, 1, 0)
      Constraint.make(stackview, .centerY, stackview.superview, .centerY, 1, 0)
      
      Constraint.make(button, .left, button.superview, .left, 1, view.width/30)
      Constraint.make(button, .right, button.superview, .right, 1, -view.width/30)
      
      constraint3 = Constraint.init(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)
      button.translatesAutoresizingMaskIntoConstraints = false
      constraint3.isActive = true
      
      //     Aspect Ratio 750 × 206
      constraint = Constraint.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 206/750, constant: 0)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      constraint.isActive = true
      
      Constraint.make(imageView, .width, stackview, .width, 1, 0)
      
      if view.height < view.width {
         constraint.constant = -view.height/15
         constraint2.constant = -view.width/10
      } else {
         constraint.constant = 0
         constraint2.constant = 0
         if view.height < 750 {
            constraint3.constant = 50
         } else {
            constraint3.constant = 70
         }
      }
      
      updateViewConstraints()
      
      
      
   }
}

extension ShopViewController {
   
   func transition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      
      func updateViews() {
         
         if size.height < size.width {
            constraint.constant = -size.height/15
            constraint2.constant = -size.width/10
         } else {
            constraint.constant = 0
            constraint2.constant = 0
         }
         label.font = UIFont.init(name: myTextFont, size: size.height/20)
         
         updateViewConstraints()
      }
      
      coordinator.animate(alongsideTransition: { (context) in
         updateViews()
      }, completion: nil)
      
   }
}
