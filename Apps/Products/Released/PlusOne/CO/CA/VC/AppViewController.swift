// app interface

import UIKit

class AppViewController: UIViewController {
   
   var stepper = StepperDriver() // done
   var stepperSound = StepperSoundDriver() // done
   var counter = CounterDriver() // done
   var page = PageDriver() // done
   var transition = TransitionDriver() // done
   var shop = ShopDriver()
   var restore = RestoreDriver()
   var pageHelper = PageHelper()
   var buy = BuyDriver()
   var counterHelper = CounterHelper()
   
   
   let stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.distribution = .fillEqually
      sv.alignment = .fill
      return sv
   }()
   
   let subStackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.distribution = .fillEqually
      sv.alignment = .fill
      return sv
   }()
   
   lazy var plusButton: UIButton = { [unowned self] in
      let b = UIButton(type: .custom)
      b.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
      return b
   }()
   
   lazy var minusButton: UIButton = { [unowned self] in
      let b = UIButton(type: .custom)
      b.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
      return b
   }()
   
   let upWorkspaceView: UIView = {
      let v = UIView()
      v.bg = .black
      return v
   }()
   
   let upVC: UpViewController = {
      let vc = UpViewController()
      return vc
   }()
   
   var tap: UITapGestureRecognizer?
   var pan: UIPanGestureRecognizer?
}

extension AppViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setupGestures()
      setupDrivers()
      
      stepperSound.isActive = true
      if pageHelper.index == 0 {
         transition.isActive = true
      }
      navigationController?.isNavigationBarHidden = true
   }

   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if !hasPresentedWT {
         defaults.set(true, forKey: Keys.walktrought)
         let wt = TutorialViewController()
         navigationController?.present(wt, animated: true, completion: nil)
      }
      
      if useCount % 5 == 0 {
         if !isReviewed {
            let vc = OVReviewViewController()
            vc.delegate = self
            navigationController?.present(vc, animated: true, completion: nil)
         }
      }
   }
}


extension AppViewController: OVReviewViewControllerDelegate {
   func appReviewed(_ complete: Bool) {
      if complete {
       defaults.set(true, forKey: Keys.review)
      }
   }
   
   func useCountPlusOne() {
      defaults.set(useCount+1, forKey: Keys.useCount)
   }
}

extension AppViewController {
   
   fileprivate func setupViews() {
      view.tag = 6
      
      
      view.addSubview(stackview)
      stackview.addArrangedSubviews(upWorkspaceView, subStackview)
      subStackview.addArrangedSubviews(plusButton, minusButton)
      
      upWorkspaceView.addSubview(upVC.view)
      
      Constraint.make("H:|[v0]|", views: stackview)
      Constraint.make("V:|[v0]|", views: stackview)
      Constraint.make("H:|[v0]|", views: upVC.view)
      Constraint.make("V:|[v0]|", views: upVC.view)
      
      addChildViewController(upVC)
   } // done
   
   fileprivate func setupDrivers() {
      setupStepper()
      setupStepperSound()
      setupCounter()
      setupPage()
      setupMenuTransition()
      setupShop()
      setupRestore()
      setupPageHelper()
      setupBuy()
      setupCounterHelper()
   }
}

extension AppViewController {
   
   fileprivate func setupStepper() {
      stepper.plusButton = plusButton
      stepper.minusButton = minusButton
      stepper.isActive = true
   } // done
   
   fileprivate func setupStepperSound() {
      stepperSound.plusButton = plusButton
      stepperSound.minusButton = minusButton
      stepperSound.isActive = true
   } // done
   
   fileprivate func setupCounter() {
      counter.upVC = upVC
      loadCounter()
   } // done
   
   fileprivate func setupPage() {
      page.workspace = upWorkspaceView
      page.currentPageView = upVC.view
      page.pan = pan
   } // done
   
   fileprivate func setupMenuTransition() {
      transition.view = upWorkspaceView
      transition.page = page
      transition.pan = pan
      transition.navigationController = navigationController
   } // done
   
   fileprivate func setupShop() {
      shop.view = stackview
      shop.up = upWorkspaceView
      shop.down = subStackview
      shop.stepper = stepper
      shop.stepperSound = stepperSound
      shop.page = page
      shop.counterDriver = counter
      shop.tap = tap
   } // done
   
   fileprivate func setupRestore() {
      restore.vc = self
   }
   
   fileprivate func setupPageHelper() {
      pageHelper.stepper = stepper
      pageHelper.stepperSound = stepperSound
      pageHelper.page = page
      pageHelper.counterDriver = counter
      pageHelper.shop = shop
      pageHelper.menu = transition
      pageHelper.setupController()
   }
   
   fileprivate func setupBuy() {
      buy.vc = self
      buy.shop = shop
      buy.pageHelper = pageHelper
      buy.restore = restore
      buy.setupController()
   }
   
   fileprivate func setupCounterHelper() {
      counterHelper.stepper = stepper
      counterHelper.stepperSound = stepperSound
      counterHelper.counter = counter
      counterHelper.setupController()
   }
   
   fileprivate func setupGestures() {
      
      tap = UITapGestureRecognizer.init()
      pan = UIPanGestureRecognizer.init()
      
      upVC.view.addGestureRecognizer(tap!)
      upVC.view.addGestureRecognizer(pan!)
   }
}

extension AppViewController {
   
   fileprivate func loadCounter() {
      if let _counter: Counter = counters.first {
         counter.set(counter: _counter)
         stepper.value = _counter.count
         stepperSound.value = _counter.count
      } else {
         let _counter = Counter.random()
         counters.append(_counter)
         counter.set(counter: _counter)
      }
   }
}

extension AppViewController {
   override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      
      func updateViews() {
         plusButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
         minusButton.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
      }
      
      coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
         updateViews()
      }, completion: nil)
      
      shop.computeFrames(with: size, and: coordinator)
   }
}

