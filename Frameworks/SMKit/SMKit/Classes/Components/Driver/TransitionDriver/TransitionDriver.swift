//
//  PresentationController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

public protocol TransitionDriverDelegate: class  {
   
   func navigationController(_ navigationController: UINavigationController,
                             willShow viewController: UIViewController,
                             animated: Bool)
}

/**
   Use a TransitionDriver object to perform a defined custom presentation with a NavigationController or a UIViewController
 
   Features:
      - This class can be used with a UINavigationController push or with a UIViewController present 
      - Easy set up method provided (or set properties directly)

 */
open class TransitionDriver: NSObject {
   
   public enum TransitionDriverOperation {
      case present
      case push
      case pop
      case dismiss
   }
   
   weak open var delegate: TransitionDriverDelegate?
   
   open var operation = TransitionDriverOperation.push
   
   open var initialFrame : FrameContext = .zero
   open var targetFrame: FrameContext = .zero
   open var finalFrame: FrameContext = .zero
   
   open var isUsingShadowView = true
   open var isUsingDimmingView = true
   
   open var shadowOffset: CGPoint = .zero
   
   open var shadowAlpha: CGFloat = 0.0
   open var dimmingAlpha: CGFloat = 0.0
   
   open var duration: TimeInterval = 0.35
   
   open var parameters: UITimingCurveProvider!
   
   open func setupProperties(operation: TransitionDriverOperation,
                             initialFrame: FrameContext,
                             targetFrame: FrameContext,
                             finalFrame: FrameContext,
                             duration: Double = 0.35,
                             parameters: UITimingCurveProvider = UISpringTimingParameters.init(dampingRatio: 0.7),
                             shadowAlpha: CGFloat = 0.5,
                             dimmingAlpha: CGFloat = 0.5)
   {
      self.operation = operation
      self.initialFrame = initialFrame
      self.targetFrame = targetFrame
      self.finalFrame = finalFrame
      self.duration = duration
      self.parameters = parameters
      self.shadowAlpha = shadowAlpha
      self.dimmingAlpha = dimmingAlpha
   }
   
   fileprivate var animator: UIViewPropertyAnimator?
   
}

extension TransitionDriver: UINavigationControllerDelegate {
   
   // MARK: UINavigationControllerDelegate - (2) methods
   
   public func navigationController(_ navigationController: UINavigationController,
                                    animationControllerFor operation: UINavigationControllerOperation,
                                    from fromVC: UIViewController,
                                    to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      switch operation {
      case .push:
         self.operation = .push
      case .pop:
         self.operation = .pop
      case .none:
         print("Log: navigationController operation == .none")
      }
      return self
   }
   
   public func navigationController(_ navigationController: UINavigationController,
                                    willShow viewController: UIViewController,
                                    animated: Bool)
   {
      delegate?.navigationController(navigationController, willShow: viewController, animated: animated)
   }
}

extension TransitionDriver: UIViewControllerTransitioningDelegate {
   
   // UIViewControllerTransitioningDelegate - (3) methods
   
   public func presentationController(forPresented presented: UIViewController,
                                      presenting: UIViewController?,
                                      source: UIViewController) -> UIPresentationController?
   {
      
      let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
      
      presentationController.setupProperties(isUsingShadowView: isUsingShadowView,
                                             isUsingDimmingView: isUsingDimmingView,
                                             initialFrame: initialFrame,
                                             targetFrame: targetFrame,
                                             finalFrame: finalFrame,
                                             shadowOffset: shadowOffset,
                                             shadowAlpha: shadowAlpha,
                                             dimmingAlpha: dimmingAlpha)
      return presentationController
   }
   
   public func animationController(forPresented presented: UIViewController,
                                   presenting: UIViewController,
                                   source: UIViewController) -> UIViewControllerAnimatedTransitioning?
   {
      return self
   }
   
   public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
   {
      return self
   }
}

extension TransitionDriver: UIViewControllerAnimatedTransitioning {
   
   // UIViewControllerAnimatedTransitioning - (2) methods
   
   public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
   {
      return duration
   }
   
   public func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
   {
      let fromView = transitionContext.view(forKey: .from)
      let toView = transitionContext.view(forKey: .to)
      let container = transitionContext.containerView
      let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
      
      
      animator = UIViewPropertyAnimator.init(duration: duration,
                                             timingParameters: parameters)
      
      if operation == .push || operation == .present {
         container.addSubview(toView!)
         
         toView?.frame = container.frame.transformBy(insetX: initialFrame.inset.dx,
                                                     insetY: initialFrame.inset.dy,
                                                     offsetX: initialFrame.offset.dy,
                                                     offsetY: initialFrame.offset.dy)
         
         func presentAnimation() {
            
            toView?.frame = container.frame.transformBy(insetX: targetFrame.inset.dx,
                                                        insetY: targetFrame.inset.dy,
                                                        offsetX: targetFrame.offset.dx,
                                                        offsetY: targetFrame.offset.dy)
         }
         
         animator?.addAnimations {
            presentAnimation()
         }
         
         if operation == .push {
            animator?.addAnimations { [unowned self] in
               fromView?.alpha = self.dimmingAlpha
            }
         }
      } else {
         // operation == .pop || operation == .dismiss
         
         if operation == .pop {
            container.insertSubview(toView!, at: 0)
            toView?.frame = finalFrame
         } else if operation == .dismiss {
            toView?.frame = finalFrame
         }
         
         func dismissAnimation() {
            
            fromView?.frame = container.frame.transformBy(insetX: self.finalFrame.inset.dx,
                                                          insetY: self.finalFrame.inset.dy,
                                                          offsetX: self.finalFrame.offset.dx,
                                                          offsetY: self.finalFrame.offset.dy)
         }
         
         animator?.addAnimations {
            dismissAnimation()
         }
         
         if operation == .pop {
            animator?.addAnimations {
               toView?.alpha = 1
            }
            
         }
      }
      
      
      animator?.addCompletion({ [unowned self] (position) in
         fromView?.removeFromSuperview()
         transitionContext.completeTransition(true)
         
         if self.operation == .push {
            self.operation = .pop
         }
         
         if self.operation == .present {
            self.operation = .dismiss
         }
      })
      
      animator?.startAnimation()
   }
}
