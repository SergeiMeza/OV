
import UIKit

/// created on 16/10/25


// see StandardHeaderView
open class SMHeaderView01: UIView {
   
   open var separatorWidth: CGFloat = 6 {
      didSet {
         if let constraint = separatorWidthConstraint {
            constraint.constant = separatorWidth
            updateConstraintsIfNeeded()
         }
      }
   }
   
   open var separatorAlpha: CGFloat = 0.5 {
      didSet {
         separatorView.alpha = separatorAlpha
      }
   }
   
   open let titleLabel: UILabel = {
      let l = UILabel.init()
      l.numberOfLines = 0
      l.text = "Hello World"
      l.textColor = UIColor.init(white: 0.05, alpha: 1)
      l.textAlignment = .center
      l.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
      return l
   }()
   
   open let rightButton: SMButton01 = {
      let b = SMButton01.init(type: .custom)
      b.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .black)
      return b
   }()
   
   open let leftButton: SMButton01 = {
      let b = SMButton01.init(type: .custom)
      return b
   }()
   
   open lazy var separatorView: UIView = { [unowned self] in
      let v = UIView()
      v.backgroundColor = UIColor.init(white: 0, alpha: self.separatorAlpha)
      return v
   }()
   
   open func setupProperties(headerColor: UIColor, separatorColor: UIColor) {
      backgroundColor = headerColor
      separatorView.backgroundColor = separatorColor
   }
   
   fileprivate var separatorWidthConstraint : Constraint? = Constraint.init() {
      didSet {
         updateConstraintsIfNeeded()
      }
   }
   
   public convenience init(separatorWidth: CGFloat, separatorAlpha: CGFloat) {
      self.init()
      self.separatorWidth = separatorWidth
      self.separatorAlpha = separatorAlpha
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      backgroundColor = .white
      
      addSubviews(titleLabel, leftButton, rightButton, separatorView)
      
      Constraint.make(titleLabel, .centerX, superView: .centerX, 1, 0)
      Constraint.make(titleLabel, .centerY, superView: .centerY, 1, 0)
      
      Constraint.make(rightButton, .right, superView: .right, 1, -8)
      Constraint.make(rightButton, .centerY, superView: .centerY, 1, 0)
      
      Constraint.make(leftButton, .left, superView: .left, 1, 8)
      Constraint.make(leftButton, .centerY, superView: .centerY, 1, 0)
      
      Constraint.make(separatorView, .top, superView: .bottom, 1, 0)
      Constraint.make(separatorView, .width, superView: .width, 1, 0)
      separatorWidthConstraint = Constraint.init(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: separatorWidth)
      separatorWidthConstraint?.isActive = true
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
}
