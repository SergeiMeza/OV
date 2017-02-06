
import UIKit
import StoreKit

// done

class MenuViewController: UIViewController
{
   
   weak var delegate : MenuViewControllerDelegate?
   
   let restore = MenuRestoreDriver()
   
   var constraint: Constraint!
   
   var restoring = false
   
   let stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.distribution = .fillEqually
      sv.alignment = .fill
      sv.spacing = 8
      return sv
   }()
   
   lazy var soundButton: UIButton = { [unowned self] in
      let b = UIButton(type: .system)
      b.tintColor = ._black
      if areSoundsActive {
         b.setTitle(soundsOn, for: .normal)
      } else {
         b.setTitle(soundsOFF, for: .normal)
      }
      b.setTitleColor(.black, for: .normal)
      let size = self.view.height
      if size != 0 {
         b.titleLabel?.font = UIFont.init(name: "HelveticaNeue-light", size: self.view.height/40)
      } else {
         b.titleLabel?.font = UIFont.init(name: "HelveticaNeue-light", size: 30)
      }
      b.addTarget(self, action:#selector(configureSounds), for:[.touchUpInside,.touchUpOutside])
      b.bg = UIColor._lightGray
   return b
   }()
   
   lazy var restoreButton: UIButton = { [unowned self] in
      let b = UIButton(type: .system)
      b.tintColor = ._black
      b.setTitle(restorePurchasesString, for: .normal)
      b.setTitleColor(.black, for: .normal)
      let size = self.view.height
      if size != 0 {
         b.titleLabel?.font = UIFont.init(name: "HelveticaNeue-light", size: self.view.height/40)
      } else {
         b.titleLabel?.font = UIFont.init(name: "HelveticaNeue-light", size: 30)
      }
      b.addTarget(self, action:#selector(restorePurchases), for:[.touchUpInside,.touchUpOutside])
      b.bg = UIColor._lightGray
      return b
   }()
   
   lazy var tutorialButton: UIButton = { [unowned self] in
      let b = UIButton(type: .system)
      b.setTitle(showTutorialString, for: .normal)
      b.setTitleColor(.black, for: .normal)
      let size = self.view.height
      if size != 0 {
         b.titleLabel?.font = UIFont.init(name: "HelveticaNeue-light", size: self.view.height/40)
      } else {
         b.titleLabel?.font = UIFont.init(name: "HelveticaNeue-light", size: 30)
      }
      b.addTarget(self, action:#selector(showTutorial), for:[.touchUpInside,.touchUpOutside])
      b.bg = UIColor._lightGray
      return b
      }()
   
   lazy var activityIndicator: UIActivityIndicatorView = {
      let actInd = UIActivityIndicatorView()
      actInd.hidesWhenStopped = true
      actInd.startAnimating()
      actInd.color = .black
      return actInd
   }()
   
}

extension MenuViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      
      restore.menuVC = self
   }
   
   private func setupViews() {
      view.tag = 7
      
      view.backgroundColor = .white
      
      view.addSubviews(stackview)
      
      stackview.addArrangedSubviews(soundButton, restoreButton, tutorialButton)
      
      Constraint.make(stackview, .centerX, .equal, view, .centerX, 1, 0)
      Constraint.make(stackview, .centerY, .equal, view, .centerY, 1, 0)
      
      stackview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.width/30).isActive = true
      stackview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.width/30).isActive = true
      
      constraint = Constraint(item: restoreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)
      restoreButton.translatesAutoresizingMaskIntoConstraints = false
      constraint.isActive = true
      
      if view.height >= 750 {
         if view.height > view.width {
            constraint.constant = 70
         } else {
            constraint.constant = 44
         }
      } else {
         constraint.constant = 44
      }
      updateViewConstraints()
   }
}

extension MenuViewController {
   
   @objc fileprivate func showTutorial() {
      let vc = TutorialViewController()
      present(vc, animated: true, completion: nil)
   }
   
   @objc fileprivate func configureSounds() {
      if soundsLoaded {
         soundsLoaded = false
         soundButton.setTitle(soundsOFF, for: .normal)
      } else {
         soundsLoaded = true
         soundButton.setTitle(soundsOn, for: .normal)
      }
   }
   
   @objc fileprivate func restorePurchases() {
      if !restoring {
         restoring = true
         restoreButton.isEnabled = false
         restoreButton.alpha = 0.0
         activityIndicator.frame = CGRect(center: CGPoint(x:restoreButton.center.y, y:restoreButton.center.y), size: restoreButton.frame.size)
         view.addSubview(activityIndicator)
         delegate?.restorePurchases?()
      }
   }
}

@objc protocol MenuViewControllerDelegate : class {
   @objc optional func restorePurchases()
}

extension MenuViewController {
   override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      
      if size.height < size.width {
         constraint.constant = 44
      } else {
         if size.height >= 750 {
            constraint.constant = 70
         } else {
            constraint.constant = 44
         }
      }
      
      func updateViews() {
         
         let buttons = [soundButton, restoreButton, tutorialButton]
         
         for b in buttons {
            if size.height < size.width {
               b.titleLabel?.font = UIFont.systemFont(ofSize: size.height/50, weight: UIFontWeightLight)
            } else {
               b.titleLabel?.font = UIFont.systemFont(ofSize: size.height/40, weight: UIFontWeightLight)
            }
         }
         
         updateViewConstraints()
      }
      
      coordinator.animate(alongsideTransition: { (context) in
         updateViews()
      }, completion: nil)
      
   }
}

