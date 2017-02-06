
import UIKit

/**
 NOTE: UIColor, UIView - constraint, cornerRadius, properties, transform, animations
 */

public typealias Color = UIColor
public typealias View = UIView

// --------------------------- UIColor --------------------------- //
// MARK: UIColor extensions

public extension UIColor {
   
   public convenience init(rgb value: Int, alpha: CGFloat) {
      self.init(red: CGFloat(((value & 0xFF0000) >> 16))/255,
         green: CGFloat(((value & 0xFF00) >> 8))/255,
         blue: CGFloat((value & 0xFF))/255,
         alpha: alpha)
   }
   
   public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
      self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
   }
   
}

// --------------------------- UIColor --------------------------- //
// MARK: UIColor extensions
// DESCRIPTION: Methods

public extension UIColor {
   
   public static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
      return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
   }
   
   public static func rgb(_ value: Int) -> UIColor {
      return UIColor(red: CGFloat(((value & 0xFF0000) >> 16))/255,
                     green: CGFloat(((value & 0xFF00) >> 8))/255,
                     blue: CGFloat((value & 0xFF))/255, alpha: 1)
   }
}

// --------------------------- UIColor --------------------------- //
// MARK: UIColor extensions
// DESCRIPTION: Properties

public extension UIColor {
   
   public var cg : CGColor { return cgColor }
   public var ci : CIColor { return ciColor }
}

public extension UIColor {
   
   static public var _white : UIColor { return UIColor(white: 0.98, alpha: 1.0) }
   static public var _black: UIColor { return UIColor(white: 0.05, alpha: 1) }
   
   static public var _lightGray : UIColor { return UIColor(white: 0.95, alpha: 1.0) }
   static public var _gray2 : UIColor { return UIColor.init(white: 0.85, alpha: 1) }
   static public var _gray : UIColor {return rgb(red: 201, green: 201, blue: 201)}
   static public var _darkGray: UIColor { return UIColor.init(red: 0.24, green: 0.24, blue: 0.24, alpha: 1) }
   
   static public var _red: UIColor {return rgb(red: 255, green: 55, blue: 55)}
   static public var _blue: UIColor {return rgb(red: 20, green: 120, blue: 255)}
   
   static public var _orange: UIColor {return rgb(red: 250, green: 150, blue: 40)}
   
   static public var frenchBlue : UIColor { return rgb(red: 6, green: 122, blue: 181) }

}

// --------------------------- UIColor --------------------------- //
// MARK: UIColor extension

public enum Lightness {
   case light, dark
}

public extension UIColor {
   func lightness() -> Lightness {
      var white: CGFloat = 0
      self.getWhite(&white, alpha: nil)
      if white < 0.9 {
         return .dark
      } else {
         return .light
      }
   }
}

// --------------------------- UIView --------------------------- //
// MARK: UIView extension
// DESCRIPTION: Init

public extension UIView {
   
   convenience public init(frame: CGRect, cornerRadius radius: CGFloat) {
      self.init(frame: frame)
      layer.cornerRadius = radius
      clipsToBounds = true
   }
}

// --------------------------- UIView --------------------------- //
// MARK: UIView extension
// DESCRIPTION: Properties

public extension UIView {
   public var bg : UIColor? { get {return backgroundColor } set { backgroundColor = newValue } }
}

// --------------------------- UIView --------------------------- //
// MARK: UIView extension
// DESCRIPTION: Anchor constraints

@available(iOS 9.0, *)
public extension UIView {
   
   public func fillSuperview() {
      addAnchors(toTop: superview!.topAnchor,
                 toRight: superview!.rightAnchor,
                 toBottom: superview!.bottomAnchor,
                 toLeft: superview!.leftAnchor)
   }
   
   public func addAnchors(toTop t: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
                       toRight r: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
                       toBottom b: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
                       toLeft l: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
                       topConstant: CGFloat = 0,
                       rightConstant: CGFloat = 0,
                       leftConstant: CGFloat = 0,
                       bottomConstant: CGFloat = 0,
                       width: CGFloat = 0,
                       height: CGFloat = 0)
   {
      translatesAutoresizingMaskIntoConstraints = false
      if let t = t {
         topAnchor.constraint(equalTo: t, constant: topConstant).isActive = true
      }
      if let b = b {
         bottomAnchor.constraint(equalTo: b, constant: -bottomConstant).isActive = true
      }
      if let l = l {
         leftAnchor.constraint(equalTo: l, constant: leftConstant).isActive = true
      }
      if let r = r {
         rightAnchor.constraint(equalTo: r, constant: -rightConstant).isActive = true
      }
      if width != 0 {
         widthAnchor.constraint(equalToConstant: width).isActive = true
      }
      if height != 0 {
         heightAnchor.constraint(equalToConstant: height).isActive = true
      }
   }
   
   public func anchorCenterToSuperView() {
      anchorCenterXToSuperview()
      anchorCenterYToSuperview()
   }
   
   public func anchorCenterXToSuperview(constant: CGFloat = 0) {
      translatesAutoresizingMaskIntoConstraints = false
      Constraint.make(self, .centerX, superView: .centerX, 1, constant)
   }
   
   public func anchorCenterYToSuperview(constant: CGFloat = 0) {
      translatesAutoresizingMaskIntoConstraints = false
      Constraint.make(self, .centerY, superView: .centerY, 1, constant)
   }
}

// --------------------------- UIView --------------------------- //
// MARK: UIView extension
// DESCRIPTION: Properties

public extension UIView {
   
   public var radius : CGFloat { return min(width/2,height/2) }
   public var r : CGFloat { return radius }
   
   public var size: CGSize {get { return frame.size } set{ frame.size = newValue } }
   public var s: CGSize {get { return size } set{ size = newValue } }
   
   public var frameSize: CGSize { get { return frame.size } set { frame.size=newValue } }
   public var boundsSize: CGSize { get { return bounds.size } set { bounds.size=newValue } }
   
   public var height : CGFloat { return frame.height }
   public var width : CGFloat { return frame.width }
   public var h : CGFloat { return height }
   public var w : CGFloat { return width }
   
   public var c : CGPoint { return frame.center }
   
   public var frameCenter : CGPoint {get{return frame.center} set{frame.center=newValue}}
   public var frameCenterX : CGFloat {get{return frameCenter.x} set{frame.centerX=newValue}}
   public var frameCenterY : CGFloat {get{return frameCenter.y} set{frame.centerY=newValue}}
   
   public var frameOrigin : CGPoint {get{return frame.origin} set{frame.origin=newValue}}
   public var frameOriginX : CGFloat {get{return frameOrigin.x} set{frameOrigin.x=newValue}}
   public var frameOriginY : CGFloat {get{return frameOrigin.y} set{frameOrigin.y=newValue}}
   
   public var frameHeight : CGFloat {return frame.height}
   public var frameWidth : CGFloat { return frame.width }
   
   public var boundsCenter : CGPoint { return bounds.center }
   public var boundsCenterX : CGFloat { return boundsCenter.x }
   public var boundsCenterY : CGFloat { return boundsCenter.y }
   
   public var boundsOrigin : CGPoint {get{return bounds.origin} set{bounds.origin=newValue}}
   public var boundsOriginX : CGFloat {get{return boundsOrigin.x} set{boundsOrigin.x=newValue}}
   public var boundsOriginY : CGFloat {get{return boundsOrigin.y} set{boundsOrigin.y=newValue}}
   
   public var boundsWidth : CGFloat {return bounds.width}
   public var boundsHeight : CGFloat { return bounds.height}

}

// --------------------------- UIView --------------------------- //
// MARK: UIView extension
// DESCRIPTION : Methods

public extension UIView {

   static public func removeFromSuperviews(views: UIView?...) {
      for view in views {
         view?.removeFromSuperview()
      }
   }
   
   public func addSubviews(_ views: UIView...) {
      for view in views {
         addSubview(view)
      }
   }
   
}

// --------------------------- UIView --------------------------- //

public extension UIView {
   
   public func move(to toPoint: CGPoint) {
      frame = CGRect(center: toPoint, size: frame.size)
   }
   
   public func identity() {
      transform = CGAffineTransform.identity
   }
   
   public func moveBy(x: CGFloat, y: CGFloat) {
      transform = CGAffineTransform(translationX: x, y: y)
   }
   
   public func moveBy(_ point: CGPoint) {
      transform = CGAffineTransform(translationX: point.x, y: point.y)
   }
   
   public func moveBy(x: CGFloat) {
      transform = CGAffineTransform(translationX: x, y: 0)
   }

   public func moveBy(y: CGFloat) {
      transform = CGAffineTransform(translationX: 0, y: y)
   }
   
   public func scaleBy(_ factor: CGFloat) {
      transform = CGAffineTransform(scaleX: factor, y: factor)
   }
   
   public func scaleXBy(_ factor: CGFloat) {
      transform = CGAffineTransform(scaleX: factor, y: 1)
   }
   
   public func scaleYBy(_ factor: CGFloat) {
      transform = CGAffineTransform(scaleX: 1, y: factor)
   }
}

// --------------------------- UIView --------------------------- //
// MARK: UIView extension
// DESCRIPTION: Animations

public extension UIView {
   
   public func fade(to v: CGFloat) {
      let timing = UISpringTimingParameters()
      let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timing)
      animator.addAnimations { [unowned self] in self.alpha = v }
      animator.startAnimation()
   }
}

public extension UIView {
   public func fadeOut() {
      if !isHidden {
         UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.alpha = 0
            }, completion: { [unowned self] _ in
               self.isHidden = true
            })
      }
   }
   
   public func fadeIn() {
      guard !(!isHidden && alpha == 1) else { return }
      
      UIView.animate(withDuration: 0.3) { [unowned self] in
         self.isHidden = false
         self.alpha = 1
      }
   }
}


public extension UIView {
   
   public func colorize(with color: UIColor, alpha: CGFloat) -> UIView {
      let colorV = UIView()
      colorV.backgroundColor = color
      colorV.frame = bounds
      colorV.alpha = alpha
      addSubview(colorV)
      return colorV
   }
   
   public func colorize(with color: UIColor, alpha: CGFloat, duration: Double, completionHandler handler: (()->())?) {
      let colorV = self.colorize(with: color, alpha: 0)
      func animation() {colorV.alpha = alpha}
      UIView.animate(withDuration: duration,
                     animations: {animation()},
                     completion: { _ in handler?()}
      )
   }
   
   public func darken(withDuration duration: Double, completionHandler handler:(()->())?) {
      self.colorize(with: .black, alpha: 0.5, duration: duration, completionHandler: handler)
   }
   
   
}

// --------------------------- UIView --------------------------- //

public extension UIView {
   
   public func addDebugView() {
      addDebugView(at: self.c, with: CGSize.make(50,50))
   }
   
   public func addDebugView(with size: CGSize) {
      addDebugView(at: self.c, with: size)
   }
   
   public func addDebugView(at atPoint: CGPoint) {
      addDebugView(at: atPoint, with: .make(50, 50))
   }
   
   public func addDebugView(at atPoint: CGPoint, with size: CGSize) {
      let v = UIView(frame: CGRect(center: atPoint, size: size))
      v.bg = ._orange
      addSubview(v)
      Constraint.make(v, .centerX, self, .centerX, 1, 0)
      Constraint.make(v, .centerY, self, .centerY, 1, 0)
   }
}
