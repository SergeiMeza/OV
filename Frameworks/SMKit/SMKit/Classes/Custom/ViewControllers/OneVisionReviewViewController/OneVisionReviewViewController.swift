//
//  OneVisionReviewViewController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

public protocol OneVisionReviewViewControllerDelegate: class {
   /// defaults.set(true, forKey: Keys.review)
   func appReviewed(_ complete: Bool)
   ///   defaults.set(useCount+1, forKey: Keys.useCount)
   func useCountPlusOne()
}


/// Description: Present/Push an OVReviewViewController object in order to review an Application in the AppStore.
/// Call the setupProperties(_ applicationID: String) method at viewDidLoad() in order to present the correct app in the AppStore.
/// You don't need to subclass this class.
open class OneVisionReviewViewController: UIViewController, OneVisionControllerDelegate
{
   
   open override var prefersStatusBarHidden: Bool {return true}
   
   open weak var delegate : OneVisionReviewViewControllerDelegate?
   
   lazy fileprivate var ovController: OneVisionController = { [unowned self] in
      let c = OneVisionController.init()
      c.setupProperties(viewController: self)
      c.delegate = self
      return c
      }()
   
   lazy fileprivate var reviewView: OneVisionReviewView = { [unowned self] in
      let v = OneVisionReviewView.init(frame: self.view.frame)
      return v
      }()
   
}

// functionality

internal extension OneVisionReviewViewController {
   
   @objc fileprivate func reviewApp() {
      // go to appstore
      ovController.reviewThisApp() { [unowned self] in
         self.presentingViewController?.dismiss(animated: true, completion: nil)
         _ = self.navigationController?.popViewController(animated: true)
      }
   }
   
   @objc fileprivate func reviewLater() {
      presentingViewController?.dismiss(animated: true, completion: nil)
      _ = navigationController?.popViewController(animated: true)
      delegate?.useCountPlusOne()
      
   }
   
   func appReview(_ completed: Bool) {
      delegate?.appReviewed(completed)
   }
}

// layout

extension OneVisionReviewViewController {
   
   open override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   fileprivate func setupViews() {
      view.bg = .white
      
      view.addSubviews(reviewView)
      reviewView.fillSuperview()
      
      reviewView.reviewButton.addTarget(self, action: #selector(reviewApp), for: [.touchUpInside])
      reviewView.laterButton.addTarget(self, action: #selector(reviewLater), for: [.touchUpInside])
      reviewView.closeButton.addTarget(self, action: #selector(reviewLater), for: .touchUpInside)
   }
   
   open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      
      super.viewWillTransition(to: size, with: coordinator)
      
      coordinator.animate(alongsideTransition: { [unowned self] (context) in
         self.reviewView.updateViewLayouts()
         }, completion: nil)
   }
}

