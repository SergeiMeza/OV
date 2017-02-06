//
//  PresentationController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit

/**
   Use this class when performing a custom UIViewController presentation 
   ** (this object was used by a TransitionDriver object)
 
   Features:
   - Present a UIViewController by setting initialFrame, targetFrame and finalFrame properties
   - optionally use shadowView and dimmingView to further customize the presentation
 
   Usage:
   - configure the properties directly or by convenience method
 
 */
public class PresentationController: UIPresentationController {
   
   open var isUsingShadowView = false
   open var isUsingDimmingView = false
   
   open var initialFrame: FrameContext = .zero
   open var targetFrame: FrameContext = .zero
   open var finalFrame: FrameContext = .zero
   
   open var shadowOffset = CGPoint.zero
   
   open var shadowAlpha: CGFloat = 0.0
   open var dimmingAlpha: CGFloat = 0.0
   
   open func setupProperties(isUsingShadowView: Bool,
                             isUsingDimmingView: Bool,
                             initialFrame: FrameContext,
                             targetFrame: FrameContext,
                             finalFrame: FrameContext,
                             shadowOffset: CGPoint,
                             shadowAlpha: CGFloat,
                             dimmingAlpha: CGFloat)
   {
      self.isUsingShadowView = isUsingShadowView
      self.isUsingDimmingView = isUsingDimmingView
      self.initialFrame = initialFrame
      self.targetFrame = targetFrame
      self.finalFrame = finalFrame
      self.shadowOffset = shadowOffset
      self.shadowAlpha = shadowAlpha
      self.dimmingAlpha = dimmingAlpha
   }
   
   open lazy var shadowView : UIView = { [unowned self] in
      let v = UIView()
      v.bg = .black
      v.alpha = self.shadowAlpha
      return v
      }()
   
   open let dimmingView: UIView = {
      let v = UIView()
      v.bg = .black
      v.alpha = 0
      return v
   }()
}


// Presentation
extension PresentationController {
   
   override open func presentationTransitionWillBegin() {
      
      guard let container = containerView else { return super.presentationTransitionWillBegin() }
      
      if isUsingShadowView {
         
         shadowView.frame = container.frame.transformBy(insetX: initialFrame.inset.dx,
                                                        insetY: initialFrame.inset.dy,
                                                        offsetX: initialFrame.offset.dx + shadowOffset.x,
                                                        offsetY: initialFrame.offset.dy + shadowOffset.y)
         
         containerView?.addSubview(shadowView)
         shadowView.addSubview(presentedViewController.view)
      }
      
      if isUsingDimmingView {
         dimmingView.frame = containerView!.frame
         containerView?.addSubview(dimmingView)
      }
      
      
      let transitionCoordinator = presentingViewController.transitionCoordinator
      
      func presentingAnimation() {
         if isUsingShadowView {
            
            shadowView.frame = container.frame.transformBy(insetX: targetFrame.inset.dx,
                                                           insetY: targetFrame.inset.dy,
                                                           offsetX: targetFrame.offset.dx + shadowOffset.x,
                                                           offsetY: targetFrame.offset.dy + shadowOffset.y)
         }
         
         if isUsingDimmingView {
            dimmingView.alpha = dimmingAlpha
         }
      }
      
      transitionCoordinator?.animate(alongsideTransition: { (context) in
         presentingAnimation()
      })
   }
   
   override open func presentationTransitionDidEnd(_ completed: Bool) {
      
      if !completed {
         if isUsingShadowView {
            shadowView.removeFromSuperview()
         }
         if isUsingDimmingView {
            dimmingView.removeFromSuperview()
         }
      }
   }
}


// dismissal
extension PresentationController {
   
   override open func dismissalTransitionWillBegin() {
      
      guard let container = containerView else { return super.dismissalTransitionWillBegin() }
      
      let transitionCoordinator = presentingViewController.transitionCoordinator
      
      func dismissalAnimation() {
         
         if isUsingShadowView {
            shadowView.frame = container.frame.transformBy(insetX: finalFrame.inset.dx,
                                                           insetY: finalFrame.inset.dy,
                                                           offsetX: finalFrame.offset.dx + shadowOffset.x,
                                                           offsetY: finalFrame.offset.dy + shadowOffset.y)
         }
         
         if isUsingDimmingView {
            dimmingView.alpha = 0
         }
      }
      
      transitionCoordinator?.animate(alongsideTransition: {(context) in
         dismissalAnimation()
      })
      
   }
   
   override open func dismissalTransitionDidEnd(_ completed: Bool) {
      
      if !completed {
         if isUsingShadowView {
            shadowView.removeFromSuperview()
         }
         if isUsingDimmingView {
            dimmingView.removeFromSuperview()
         }
      }
   }
}


/**
 Use this struct to define a frame position and size on screen by modifying the containerView object of UIPresentationControllere
 
 - inset: (dx:CGFloat, dy: CGFloat)
 - offset: (dx:CGFloat, dy: CGFloat)
 
 */
public struct FrameContext {
   
   static let zero: FrameContext = FrameContext(insetXY: (0, 0), offsetXY: (0, 0))
   
   public var inset: (dx: CGFloat, dy: CGFloat)
   public var offset: (dx: CGFloat, dy: CGFloat)
   
   public init(insetXY: (CGFloat,CGFloat), offsetXY: (CGFloat, CGFloat)) {
      self.inset = (insetXY.0, insetXY.1)
      self.offset = (offsetXY.0, offsetXY.1)
   }
}
