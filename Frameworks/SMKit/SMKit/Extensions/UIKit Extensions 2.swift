

import UIKit

/**
 NOTE: UIView - Blur, shadow, roundness
 */

// --------------------------- UIView --------------------------- //

public extension UIView {
   
   public enum UIViewShadow: Int {
      case none=0, ultraLight, light, medium, strong
   }
   
   public func roundedView(radius: CGFloat) -> UIView {
      clipsToBounds = true
      layer.cornerRadius = radius
      let view = UIView(frame: CGRect(center: frameCenter, size: frameSize))
      view.addSubview(self)
      return view
   }
   
   public func addShadow(level l: UIViewShadow) {
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = CGSize(width: 0, height: 0)
      switch l {
      case .none: layer.shadowOpacity = 0
      case .ultraLight: layer.shadowOpacity = 0.05
      case .light: layer.shadowOpacity = 0.1
      case .medium: layer.shadowOpacity = 0.2
      case .strong: layer.shadowOpacity = 0.3
      }
   }
   
   public func removeShadow() {
      layer.shadowColor = nil
      layer.shadowOpacity = 0
   }
   
   public func addShadowToRoundedView(radius r: CGFloat, level l: UIViewShadow) {
      addShadow(level: l)
      clipsToBounds = false
      layer.cornerRadius = r
      
      switch l {
      case .none: layer.shadowRadius = 0
      case .ultraLight: layer.shadowRadius = 3
      case .light: layer.shadowRadius = 6
      case .medium: layer.shadowRadius = 9
      case .strong: layer.shadowRadius = 12
      }
   }
   
   public func roundedView(radius: CGFloat, shadow l: UIViewShadow) -> UIView {
      let roundedV = self.roundedView(radius: radius)
      roundedV.addShadowToRoundedView(radius: radius, level: l)
      return roundedV
   }
}

// --------------------------- UIView --------------------------- //

public extension UIView {
   
   fileprivate func makeBlur(style: UIBlurEffectStyle) -> (blur:UIBlurEffect,blurView:UIVisualEffectView) {
      let blur = UIBlurEffect(style: style)
      let blurView = UIVisualEffectView()
      blurView.frame = bounds
      return (blur,blurView)
   }
   
   public func addBlur(style: UIBlurEffectStyle) -> (blur:UIBlurEffect,blurView:UIVisualEffectView) {
      let p = makeBlur(style: style)
      p.blurView.effect = p.blur
      addSubview(p.blurView)
      Constraint.make("H:|[v0]|", views: p.blurView)
      Constraint.make("V:|[v0]|", views: p.blurView)
      return p
   }
   
   public func addRoundedBlur(style: UIBlurEffectStyle) -> (blur:UIBlurEffect,blurView:UIVisualEffectView) {
      let p = addBlur(style: style)
      p.blurView.layer.cornerRadius = p.blurView.r
      p.blurView.clipsToBounds = true
      return p
   }
   
   public func addBlur(style: UIBlurEffectStyle, duration: Double, completion handler: (()->())? ) -> (blur: UIBlurEffect, blurView: UIVisualEffectView) {
      
      let p = makeBlur(style: style)
      addSubview(p.blurView)
      Constraint.make("H:|[v0]|", views: p.blurView)
      Constraint.make("V:|[v0]|", views: p.blurView)
      
      func animation() {
         p.blurView.effect = p.blur
      }
      
      UIView.animate(withDuration: duration,
                     animations: { animation() },
                     completion: { _ in handler?() }
      )
      return p
   }
   
   public func blur(style: UIBlurEffectStyle, duration: Double, completion handler: (()->())? ) -> (blur:UIBlurEffect, blurView:UIVisualEffectView) {
      return addBlur(style: style, duration: duration, completion: handler)
   }
   
   fileprivate func makeBlur(style: UIBlurEffectStyle, vibrancyViews: [UIView]) -> (blur: UIBlurEffect, blurView: UIVisualEffectView, vibrancy: UIVibrancyEffect, vibrancyView: UIVisualEffectView) {
      let blurProp = makeBlur(style: style)
      let vibrancy = UIVibrancyEffect(blurEffect: blurProp.blur)
      let vibrancyView = UIVisualEffectView()
      vibrancyView.frame = blurProp.blurView.frame
      
      for view in vibrancyViews {
         vibrancyView.contentView.addSubviews(view)
      }
      blurProp.blurView.contentView.addSubview(vibrancyView)
      
      return (blurProp.blur,blurProp.blurView,vibrancy,vibrancyView)
   }
   
   public func addBlur(style: UIBlurEffectStyle, duration:Double, completion handler: (()->())?, vibrancyViews views: [UIView]) -> (blurView:UIVisualEffectView,vibrancyView:UIVisualEffectView) {
      
      let p = makeBlur(style: style, vibrancyViews: views)
      addSubview(p.blurView)
      
      Constraint.make("H:|[v0]|", views: p.blurView)
      Constraint.make("V:|[v0]|", views: p.blurView)
      Constraint.make("H:|[v0]|", views: p.vibrancyView)
      Constraint.make("V:|[v0]|", views: p.vibrancyView)
      
      func animation1() {
         p.blurView.effect = p.blur
         p.vibrancyView.effect = p.vibrancy
      }
      
      UIView.animate(withDuration:duration,
                     animations:{ animation1() },
                     completion:{_ in handler?() }
      )
      
      return (p.blurView,p.vibrancyView)
   }
   
   public func addBlur(style: UIBlurEffectStyle, duration:Double, completion handler: (()->())?, vibrancyViews views: UIView...) -> (blurView:UIVisualEffectView,vibrancyView:UIVisualEffectView) {
      return addBlur(style: style, duration: duration, completion: handler, vibrancyViews: views)
   }
   
   public func blur(style: UIBlurEffectStyle, duration: Double, completion handler: (()->())?, vibrancyViews views: UIView...) -> (blurView: UIVisualEffectView, vibrancyView: UIVisualEffectView) {
      return addBlur(style: style, duration: duration, completion: handler, vibrancyViews: views)
   }
}


// --------------------------- UITextView --------------------------- //
// MARK: UITextView extension
// DESCRIPTION: want to autocompute the size (i.e. height) of a given text view x__x

extension UITextView {
   // buggy...
   func computeSize() -> CGSize {
      return attributedText.boundingRect(with: .make(1000, 1000), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
   }
}

// --------------------------- UIImageView --------------------------- //
// MARK: UIImageView extension

public extension UIImageView {
   
   public class func roundedImage(radius: CGFloat, named: String, contentMode: UIViewContentMode) -> UIView {
      let imV = UIImageView()
      imV.frame.size = CGSize(width:2*radius,height:2*radius)
      imV.image = UIImage(named: named)
      imV.contentMode = contentMode
      let roundedImV = imV.roundedView(radius: radius)
      return roundedImV
   }
   
   public class func roundedImage(radius: CGFloat, named: String, contentMode: UIViewContentMode, shadowLevel shadow: UIViewShadow) -> UIView {
      let imV = roundedImage(radius: radius, named: named, contentMode: contentMode)
      imV.addShadowToRoundedView(radius: radius, level: shadow)
      return imV
   }
}



