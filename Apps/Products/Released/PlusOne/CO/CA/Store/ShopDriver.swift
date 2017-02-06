
import UIKit
import AudioToolbox

class ShopDriver: NSObject {
   
   var delegate: ShopDriverDelegate!
   
   weak var stepper: StepperDriver!
   weak var stepperSound: StepperSoundDriver!
   weak var counterDriver: CounterDriver!
   weak var page: PageDriver!
   
   weak var up: UIView!
   weak var down: UIView!
   weak var view: UIView!
   
   weak var tap: UITapGestureRecognizer!
   
   var isActive = false {
      didSet {
         if isActive {
            setupController()
         } else {
            unsetController()
         }
      }
   }
   
   let shopViewController = ShopViewController()
   fileprivate var shopView: UIView?
   
   fileprivate var isAnimating = false {
      didSet {
         if isAnimating {
            page.isActive = false
         } else {
            page.isActive = true
         }
      }
   }
   fileprivate var allowsAnimation = true
   
   let duration = 0.3
   
   let activityIndicator : UIActivityIndicatorView = {
      let actInd = UIActivityIndicatorView()
      actInd.hidesWhenStopped = true
      return actInd
   }()
   
}

extension ShopDriver {
   
   fileprivate func setupController() {
      stepper.isActive = false
      stepperSound.isActive = false
      counterDriver.isUserInteractionEnabled = false
      
      stepper.plusButton?.addTarget(self, action: #selector(plusDown), for: .touchDown)
      stepper.plusButton?.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside])
      stepper.minusButton?.addTarget(self, action: #selector(minusDown), for: .touchDown)
      stepper.minusButton?.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside])
      
      tap.addTarget(self, action: #selector(tapped))
   }
   
   fileprivate func unsetController() {
      stepper.plusButton?.removeTarget(nil, action: nil, for: [.touchDown, .touchUpInside, .touchUpOutside])
      stepper.minusButton?.removeTarget(nil, action: nil, for: [.touchDown, .touchUpInside, .touchUpOutside])
      
      if let tap = tap {
         tap.removeTarget(nil, action: nil)
      }
      
      stepper.isActive = true
      stepperSound.isActive = true
      counterDriver.isUserInteractionEnabled = true
   }
   
   fileprivate func configureShopView() {
      shopView = shopViewController.view
      
      if let shopView = shopView {
         view.insertSubview(shopView, at: 0)
         shopView.isUserInteractionEnabled = true
         shopViewController.button.addTarget(self, action: #selector(buyButtonTapped), for: [.touchUpInside, .touchUpOutside])
      }
      
      if let shopView = shopView {
         Constraint.make(shopView, .centerX, view, .centerX, 1, 0)
         Constraint.make(shopView, .centerY, view, .centerY, 1, 0)
         Constraint.make(shopView, .width, view, .width, 1, 0)
         Constraint.make(shopView, .height, view, .height, 0.5, 0)
      }
      
      
   }
}

extension ShopDriver {
   
   @objc fileprivate func touchUp(button: UIButton) {
      button.backgroundColor = .unselectedButtonColor
   }
   
   func handleAnimation() {
      if shopView == nil {
         configureShopView()
      }
      
      func animation() {
         up.moveBy(y: up.frameOriginY - up.frameHeight / 2)
         down.moveBy(y: down.frameOriginY - down.frameHeight / 2)
      }
      
      func completion() {
         allowsAnimation = true
         view.bringSubview(toFront: shopView!)
      }
      
      func animationBack() {
         allowsAnimation = false
         view.sendSubview(toBack: shopView!)
         up.identity()
         down.identity()
      }
      
      func completionBack() {
         allowsAnimation = true
         shopView?.removeFromSuperview()
         shopView = nil
         page.isActive = true
      }
      
      if allowsAnimation {
         if !isAnimating {
            allowsAnimation = false
            isAnimating = true
            UIView.animate(withDuration: duration, animations: {
               animation()
               }, completion: { _ in
                  completion()
            })
         } else {
            isAnimating = false
            UIView.animate(withDuration: duration, animations: {
               animationBack()
               }, completion: { _ in
                  completionBack()
            })
         }
      }
   }
}

extension ShopDriver {
   
   @objc fileprivate func buyButtonTapped(_ button: UIButton) {
      button.isHidden = true
      let center = button.center
      let size = CGSize(width: 50, height: 50)
      activityIndicator.frame = CGRect(center: center, size: size)
      activityIndicator.activityIndicatorViewStyle = .whiteLarge
      activityIndicator.color = UIColor.black
      activityIndicator.startAnimating()
      button.addSubview(activityIndicator)
      delegate.buyButtonTapped(button)
   }
   
   @objc fileprivate func plusDown(button: UIButton) {
      button.backgroundColor = .selectedButtonColor
      if allowsAnimation {
         if !isAnimating {
            AudioServicesPlaySystemSound(addSound)
         } else {
            AudioServicesPlaySystemSound(zeroSound)
         }
      }
      handleAnimation()
   }
   
   @objc fileprivate func minusDown(button: UIButton) {
      button.backgroundColor = .selectedButtonColor
      if allowsAnimation {
         if !isAnimating {
            AudioServicesPlaySystemSound(minusSound)
         } else {
            AudioServicesPlaySystemSound(zeroSound)
         }
      }
      handleAnimation()
   }
   
   @objc fileprivate func tapped() {
      if allowsAnimation {
         if isAnimating {
            AudioServicesPlaySystemSound(zeroSound)
         }
      }
      handleAnimation()
   }
}

extension ShopDriver {
   
   open func computeFrames(with size: CGSize, and coordinator: UIViewControllerTransitionCoordinator) {
      
      shopViewController.transition(to: size, with: coordinator)
      
      if isAnimating {
         if shopView != nil {
            up.transform = .identity
            down.transform = .identity
            func animateWithCoordinator() {
               up.moveBy(y: -size.height/4)
               down.moveBy(y: size.height/4)
            }
            
            coordinator.animate(alongsideTransition: {(_) in
               animateWithCoordinator()
               }, completion: nil)
         }
      }
   }
   
   open func cancelBuy() {
      shopViewController.button.isHidden = false
      activityIndicator.removeFromSuperview()
   }
}

@objc protocol ShopDriverDelegate : class
{
   func buyButtonTapped(_ button: UIButton)
}

