
import UIKit

/**
 NOTE: CGPoint, CGSize and CGRect extensions
 */

// --------------------------- CGPoint --------------------------- //
// MARK: CGPoint extension

public extension CGPoint {
   
   static public func make(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
      return CGPoint(x: x, y: y)
   }
}

// --------------------------- CGPoint --------------------------- //

public extension CGPoint {
   
   static public func + (l:CGPoint, r:CGPoint) -> CGPoint {
      return CGPoint(x: l.x + r.x, y: l.y + r.y)
   }
   
   static public func - (l:CGPoint, r:CGPoint) -> CGPoint {
      return CGPoint(x: l.x - r.x, y: l.y - r.y)
   }
   
   static public func * (l: CGFloat, r: CGPoint) -> CGPoint {
      return CGPoint(x: l * r.x, y: l * r.y)
   }
   
   static public func * (l:CGPoint,r:CGFloat) -> CGPoint {
      return CGPoint(x: l.x*r, y: l.y*r)
   }
   
   static public func / (l:CGPoint,r:CGFloat) -> CGPoint {
      return CGPoint(x:l.x/r, y: l.y/r)
   }
}

// --------------------------- CGPoint --------------------------- //

public extension CGPoint {
   
   // do I need this one??
   public func applyingTranslation(x: CGFloat, y: CGFloat) -> CGPoint {
      return applying(CGAffineTransform(translationX: x, y: y))
   }
}

// --------------------------- CGSize --------------------------- //
// MARK: CGSize extension

public extension CGSize {
   
   static public var square : CGSize { return CGSize.make(50, 50) }
   
   static public func make(_ w: CGFloat, _ h: CGFloat) -> CGSize {
      return CGSize(width: w, height: h)
   }
}

public extension CGSize {
   static public func + (l: CGSize, r: CGSize) -> CGSize {
      return .make(l.width+r.width, l.height+r.height)
   }
}


// --------------------------- CGRect --------------------------- //
// MARK: CGRect extension

public extension CGRect {
   
   public init(center: CGPoint, size: CGSize) {
      self.init()
      self.size = size
      self.origin = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
   }
   
   public init(center: CGPoint, radius: CGFloat) {
      self.init()
      self.size = .make(radius*2, radius*2)
      self.origin = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
   }
}

// --------------------------- CGRect --------------------------- //
public extension CGRect {
   
   static public func make(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
      return CGRect(origin: CGPoint(x:x,y:y), size: CGSize(width: width, height: height))
   }
   
   public func transformBy(insetX: CGFloat, insetY: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> CGRect {
      return self.insetBy(dx: insetX, dy: insetY).offsetBy(dx: offsetX, dy: offsetY)
   }
}

// --------------------------- CGRect --------------------------- //

public extension CGRect {
   
   public var center: CGPoint {get{return CGPoint(x:origin.x+size.width/2,y:origin.y+size.height/2)}
      set{origin=CGPoint(x: newValue.x-size.width/2, y: newValue.y-size.height/2)}}
   
   public var centerUp: CGPoint {get{return CGPoint(x:centerX,y:centerY-height/2)} set{center=CGPoint(x:newValue.x,y:newValue.y+height/2)}}
   public var centerDown: CGPoint {get{return CGPoint(x:centerX,y:centerY+height/2)} set{center=CGPoint(x:newValue.x,y:newValue.y-height/2)}}
   
   public var centerLeft: CGPoint {get{return CGPoint(x:centerX-width/2,y:centerY)} set{center=CGPoint(x:newValue.x+width/2,y:newValue.y)}}
   public var centerRight: CGPoint {get{return CGPoint(x:centerX+width/2,y:centerY)} set{center=CGPoint(x:newValue.x-width/2,y:newValue.y)}}
   
   public var upLeftCorner: CGPoint {get{return origin} set{origin=newValue}}
   public var upRightCorner: CGPoint {get{return CGPoint(x:origin.x+width, y:origin.y)} set{origin=CGPoint(x:newValue.x-width,y:newValue.y)}}
   public var downLeftCorner: CGPoint {get{return CGPoint(x:origin.x, y:origin.y+height)} set{origin=CGPoint(x:newValue.x,y:newValue.y-height)}}
   public var downRightCorner: CGPoint {get{return CGPoint(x:origin.x+width, y:origin.y+height)} set{origin=CGPoint(x:newValue.x-width,y:newValue.y-height)}}
   
   public var leftMiddle: CGPoint {get{return CGPoint(x:origin.x,y:origin.y+height/2)} set{origin=CGPoint(x:newValue.x,y: newValue.y-height/2)}}
   public var upMiddle: CGPoint {get{return CGPoint(x:origin.x+width/2,y:origin.y)} set{origin=CGPoint(x:newValue.x-width/2,y:newValue.y)}}
   public var rightMiddle: CGPoint {get{return CGPoint(x:origin.x+width,y:origin.y+height/2)} set{origin=CGPoint(x:newValue.x-width, y:newValue.y-height/2)}}
   public var downMiddle: CGPoint {get{return CGPoint(x:origin.x+width/2,y:origin.y+height)}set{origin=CGPoint(x:newValue.x-width/2,y:newValue.y-height)}}
   
   public var centerX: CGFloat {get{return center.x} set{center.x=newValue}}
   public var centerY: CGFloat {get{return center.y} set{center.y=newValue}}
   
   public var originX: CGFloat {get{return origin.x} set{origin.x=newValue}}
   public var originY: CGFloat {get{return origin.y} set{origin.y=newValue}}
}

public extension CGRect {
   
   static public func normalize(points :CGPoint...) -> [CGPoint] {
      guard points.count >= 1 else { return [] }
      return points.sorted { return $0.y < $1.y }
   }
   
   static public func center(of points: CGPoint...) -> CGPoint {
      guard points.count >= 1 else {return .zero }
      var x: CGFloat = 0
      var y: CGFloat = 0
      for p in points {
         x += p.x
         y += p.y
      }
      return .make(x,y)/CGFloat(points.count)
   }
   
   static public func normalizedPoints(a:CGPoint,b:CGPoint) -> (up:CGPoint,down:CGPoint) {
      if a.y < b.y { return (a,b) }
      return (b,a)
   }
}

public extension CGRect {
   // do I need this one??

   public enum TouchInCGRect:Int {
      case upperHalf=0,lowerHalf
   }
   
   public func touchLocation(at atPoint:CGPoint) -> TouchInCGRect {
      if atPoint.y > center.y {return .lowerHalf}
      return .upperHalf
   }
}

