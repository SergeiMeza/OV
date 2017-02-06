//
//  OneVisionAboutViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//


import UIKit
import Social
import Accounts
import MessageUI

public protocol OneVisionAboutViewControllerDelegate:class {
   /// defaults.set(true, forKey: Keys.review)
   func appReview(_ complete:Bool)
   ///   defaults.set(useCount+1, forKey: Keys.useCount)
   func useCountPlusOne()
}

/// Description: Present/Push an OVAboutViewController01 object in order to present more information about the studio to the user.
/// Call the setupProperties(otherApps: [String]?) method at viewDidLoad() in order to be able to present a list of the current apps to the user.
/// You don't need to subclass this class.
open class OneVisionAboutViewController: UIViewController {
   
   open weak var delegate: OneVisionAboutViewControllerDelegate?
   
   open var hideCloseButton = false
   
   fileprivate func hideButton(_ hides: Bool) {
      logoView.closeButton.alpha = 0
      logoView.closeButton.isHidden = hides
      logoView.closeButton.removeTarget(self, action: nil, for: .touchUpInside)
      view.updateConstraintsIfNeeded()
   }
   
   open override var prefersStatusBarHidden: Bool { return true }
   
   fileprivate var isShowing = false
   fileprivate var isAnimating = false
   
   fileprivate var constraint: Constraint! // ??
   
   lazy var controller : OneVisionController = { [unowned self] in
      let c = OneVisionController.init()
      c.setupProperties(viewController: self)
      return c
      }()
   
   fileprivate lazy var logoView: OneVisionAboutView = { [unowned self] in
      let v = OneVisionAboutView.init(frame: self.view.frame)
      return v
      }()
}

// functionality

extension OneVisionAboutViewController {
   
   func showApps() {
      let vc = OneVisionApptoreTableViewController()
      navigationController?.pushViewController(vc, animated: true)
   }
   
   func reviewApp() {
      controller.reviewThisApp()
      delegate?.appReview(true)
   }
   
   func followOnTwitter() {
      controller.followOnTwitter()
   }
   
   func subscribe() {
      controller.subscribe()
   }
   
   func contactUs() {
      controller.contactUs()
   }
   
   func dismissOrPop() {
      presentingViewController?.dismiss(animated: true, completion: nil)
      _ = navigationController?.popViewController(animated: true)
   }
}

// layout

extension OneVisionAboutViewController {
   
   @objc fileprivate func showContent() {
      if !isAnimating {
         isAnimating = true
         
         let fadingAnimator = UIViewPropertyAnimator(duration: 0.4, timingParameters: UICubicTimingParameters.init(animationCurve: .easeInOut))
         
         let buttons = [logoView.appsButton, logoView.followButton, logoView.newsletterButton, logoView.contactButton]
         
         let animator = UIViewPropertyAnimator(duration: 0, timingParameters: UISpringTimingParameters())
         
         if !isShowing  {
            isShowing = true
            func animation() {
               logoView.logoButton.setImage(UIImage.init(named: "logo-noFill"), for: .normal)
               logoView.appStackview.alpha = 1
               logoView.appDescriptionLabel.alpha = 1
            }
            
            var i = 0
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].identity()
               buttons[i].alpha = 1
            }, completion: nil)
            i += 1
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].identity()
               buttons[i].alpha = 1
            }, completion: nil)
            i += 1
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].identity()
               buttons[i].alpha = 1
            }, completion: nil)
            i += 1
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].identity()
               buttons[i].alpha = 1
            }, completion: { [unowned self] _ in
               self.isAnimating = false
            } )
            
            fadingAnimator.addAnimations {
               animation()
            }
         } else {
            isShowing = false
            func animation() {
               logoView.logoButton.setImage(UIImage.init(named: "logo-fill"), for: .normal)
               logoView.appStackview.alpha = 0
               logoView.appDescriptionLabel.alpha = 0
            }
            
            var i = 0
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].scaleBy(0.001)
               buttons[i].alpha = 0
            }, completion: nil)
            i += 1
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].scaleBy(0.001)
               buttons[i].alpha = 0
            }, completion: nil)
            i += 1
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].scaleBy(0.001)
               buttons[i].alpha = 0
            }, completion: nil)
            i += 1
            UIView.animate(withDuration: 0.4, delay: 0.15 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
               buttons[i].scaleBy(0.001)
               buttons[i].alpha = 0
            }, completion: {[unowned self] _ in
               self.isAnimating = false
            })
            
            fadingAnimator.addAnimations {
               animation()
            }
         }
         
         fadingAnimator.startAnimation()
      }
   }
}

extension OneVisionAboutViewController {
   
   override open func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setupControllers()
      transformButtons()
      logoView.updateSubviews()
      hideButton(hideCloseButton)
   }
   
   open func setupViews() {
      view.bg = .white
      view.addSubviews(logoView)
      logoView.fillSuperview()
   }
   
   
   open func setupControllers() {
      logoView.logoButton.addTarget(self, action: #selector(showContent), for: [.touchUpInside])
      logoView.appsButton.addTarget(self, action: #selector(showApps), for: [.touchUpInside, .touchUpOutside])
      logoView.reviewButton.addTarget(self, action: #selector(reviewApp), for: [.touchUpInside])
      logoView.followButton.addTarget(self, action: #selector(followOnTwitter), for: [.touchUpInside])
      logoView.newsletterButton.addTarget(self, action: #selector(subscribe), for: [.touchUpInside])
      logoView.contactButton.addTarget(self, action: #selector(contactUs), for: [.touchUpInside])
      logoView.closeButton.addTarget(self, action: #selector(dismissOrPop), for: .touchUpInside)
   }
   
   open func transformButtons() {
      
      func transform(_ buttons: UIButton...) {
         for b in buttons {
            b.scaleBy(0.001)
            b.alpha = 0
         }
      }
      
      transform(logoView.appsButton, logoView.followButton, logoView.newsletterButton, logoView.contactButton)
   }
}


extension OneVisionAboutViewController {
   
   open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      
      coordinator.animate(alongsideTransition: { [unowned self] (context) in
         self.logoView.updateSubviews()
         }, completion: nil)
   }
}


