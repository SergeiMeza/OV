
import SMKit



/// TableViewCell
class SideViewTableViewCell: DatasourceTableViewCell {
   
   var actionIconsFollowSliding = true
   var actionIconsMargin: CGFloat = 20
   var actionNormalColor =  UIColor.init(white: 0.85, alpha: 1)
   
   
   override var datasourceItem: Any? {
      didSet {
         if let item = datasourceItem as? String {
            textLabel?.text = item
         }
      }
   }
   
   override var center: CGPoint {
      get {
         return super.center
      }
      set {
         super.center = newValue
         updateSideViews()
      }
   }
   
   override var frame: CGRect {
      get {
         return super.frame
      }
      set {
         super.frame = newValue
         updateSideViews()
      }
   }
   
   // MARK: Private Properties
   
   var leftSideView = TableViewCellSideView()
   var rightSideView = TableViewCellSideView()
   
   var firstLeftAction: TableViewCellAction? {
      didSet {
         if (firstLeftAction?.fraction == 0) {
            firstLeftAction?.fraction = 0.3
         }
      }
   }
   
   var secondLeftAction: TableViewCellAction? {
      didSet {
         if (secondLeftAction?.fraction == 0) {
            secondLeftAction?.fraction = 0.7
         }
      }
   }
   
   var firstRightAction: TableViewCellAction? {
      didSet {
         if (firstRightAction?.fraction == 0) {
            firstRightAction?.fraction = 0.3
         }
      }
   }
   
   var secondRightAction: TableViewCellAction? {
      didSet {
         if (secondRightAction?.fraction == 0) {
            secondRightAction?.fraction = 0.7
         }
      }
   }
   
   var currentAction: TableViewCellAction?
   
   
   fileprivate lazy var tableView: UITableView = { [unowned self] in
      return self.controller!.tableView
   }()
   
   fileprivate let pan = UIPanGestureRecognizer()
   
   // MARK: Methods
   
   override func setupViews() {
      super.setupViews()
      pan.addTarget(self, action: #selector(panned))
      pan.delegate = self
      addGestureRecognizer(pan)
   }
   
   func percentageOffsetFromCenter() -> Double {
      let diff = fabs(frame.width/2 - center.x)
      return Double(diff / frame.width)
   }
   
   func percentageOffsetFromEnd() -> Double {
      let diff = fabs(frame.width/2 - center.x)
      return Double((frame.width-diff)/frame.width)
   }
}

extension SideViewTableViewCell {
   
   // MARK: Methods
   
   func panned(_ g: UIPanGestureRecognizer) {
      if !hasAnyLeftAction() || !hasAnyRightAction() {
         return
      }
      
      var horizontalTranslation = g.translation(in: self).x
      
      if g.state == .began {
         setupSideViews()
      } else if g.state == .changed {
         if (!hasAnyLeftAction() &&
            frame.width/2 + horizontalTranslation > frame.width/2) ||
            (!hasAnyRightAction() && frame.size.width/2 + horizontalTranslation < frame.size.width/2)
         {
            horizontalTranslation = 0
         }
         performChanges()
         center = CGPoint(x: frame.width/2 + horizontalTranslation, y: center.y)
      } else if g.state == .ended {
         if (currentAction == nil && frame.originX != 0) {
            (controller as! ViewController).cellReplacingBlock?(tableView, self)
         } else {
            currentAction?.didTriggerBlock(tableView, self)
         }
         currentAction = nil
      }
   }
   
   func updateSideViews() {
      leftSideView.frame = CGRect(x: 0, y: frame.originY, width: frame.originX, height: frame.height)
      if let image = leftSideView.iconImageView.image {
         leftSideView.iconImageView.frame = CGRect(x: actionIconsMargin, y: 0, width: max(image.size.width, leftSideView.frame.width - actionIconsMargin*2), height: leftSideView.frame.height)
      }
      rightSideView.frame = CGRect(x: frame.originX + frame.width, y: frame.originY, width: frame.width - (frame.originX + frame.width), height: frame.height)
      if let image = rightSideView.iconImageView.image {
         rightSideView.iconImageView.frame = CGRect(x: rightSideView.frame.width - actionIconsMargin, y: 0, width: min(-image.size.width, actionIconsMargin*2 - rightSideView.frame.width), height: rightSideView.frame.height)
      }
   }

   override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return false
   }
   
   override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
         let g = gestureRecognizer as! UIPanGestureRecognizer
         let velocity = g.velocity(in: self)
         let horizontalLocation = g.location(in: self).x
         if fabs(velocity.x) > fabs(velocity.y) &&
            horizontalLocation > (controller as! ViewController).edgeSlidingMargin &&
            horizontalLocation < frame.width - (controller as! ViewController).edgeSlidingMargin {
            return true
         }
      }
      //else if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
        // return true
      //}
      return false
   }
   
   func actionForCurrentPosition() -> TableViewCellAction? {
      let fraction = fabs(frame.originX/frame.width)
      if frame.originX > 0 {
         if (secondLeftAction != nil) && fraction > secondLeftAction!.fraction {
            return secondLeftAction!
         } else if (firstLeftAction != nil) && fraction > firstLeftAction!.fraction {
            return firstLeftAction!
         }
      } else if frame.originX < 0 {
         if (secondRightAction != nil) && fraction > secondRightAction!.fraction {
            return secondRightAction!
         } else if (firstRightAction != nil) && fraction > firstRightAction!.fraction {
            return firstLeftAction!
         }
      }
      return nil
   }
   
   func performChanges() {
      let action = actionForCurrentPosition()
      if let action = action {
         if frame.originX > 0 {
            leftSideView.bg = action.color
            leftSideView.iconImageView.image = action.icon
         } else if frame.originX < 0 {
            rightSideView.bg = action.color
            rightSideView.iconImageView.image = action.icon
         }
      } else {
         if frame.originX > 0 {
            leftSideView.bg = actionNormalColor
            leftSideView.iconImageView.image = firstLeftAction!.icon
         } else if frame.originX < 0 {
            rightSideView.bg = actionNormalColor
            rightSideView.iconImageView.image = firstRightAction!.icon
         }
      }
      if let image = leftSideView.iconImageView.image {
         leftSideView.iconImageView.alpha = frame.originX / (actionIconsMargin*2 + image.size.width)
      }
      if let image = rightSideView.iconImageView.image {
         rightSideView.iconImageView.alpha = -(frame.originX / (actionIconsMargin*2 + image.size.width))
      }
      if currentAction != action {
         action?.didHighlightBlock?(tableView, self)
         currentAction?.didUnhighlightBlock?(tableView, self)
         currentAction = action
      }
   }
   
   func hasAnyLeftAction() -> Bool {
      return firstLeftAction != nil || secondLeftAction != nil
   }
   
   func hasAnyRightAction() -> Bool {
      return firstRightAction != nil || secondRightAction != nil
   }
   
   func setupSideViews() {
      leftSideView.iconImageView.contentMode = actionIconsFollowSliding ? UIViewContentMode.right : UIViewContentMode.left
      rightSideView.iconImageView.contentMode = actionIconsFollowSliding ? UIViewContentMode.left : UIViewContentMode.right
      superview?.insertSubview(leftSideView, at: 0)
      superview?.insertSubview(rightSideView, at: 0)
   }
}


// MARK: -
// MARK: TVCSideView


// A side view displayed when the tableViewCell is panned horizontally
class TableViewCellSideView: View {
   
   let iconImageView: UIImageView!
   
   init(iconImageView: UIImageView) {
      self.iconImageView = iconImageView
      super.init(frame: .init(origin: .zero, size: iconImageView.frame.size))
      addSubview(iconImageView)
   }
   
   override init(frame: CGRect) {
      iconImageView = UIImageView()
      super.init(frame: frame)
      addSubview(iconImageView)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}

// MARK: -
// MARK: TVCAction

class TableViewCellAction: NSObject {
   
   var icon: UIImage
   var color: UIColor
   var fraction: CGFloat
   var didTriggerBlock: ((UITableView,UITableViewCell)-> ())
   var didHighlightBlock: ((UITableView,UITableViewCell)->())?
   var didUnhighlightBlock:  ((UITableView,UITableViewCell)->())?
   
   init(icon: UIImage, color: UIColor, fraction: CGFloat, didTriggerBlock:@escaping (UITableView,UITableViewCell)->()) {
      self.icon = icon
      self.color = color
      self.fraction = fraction
      self.didTriggerBlock = didTriggerBlock
      super.init()
   }
}
