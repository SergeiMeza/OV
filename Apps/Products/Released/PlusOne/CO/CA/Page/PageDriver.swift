
import UIKit

class PageDriver : NSObject, TagViewControllerDelegate
{
   weak var delegate: PageDriverDelegate?
   
   var isActive = true {
      didSet {
         if isActive {
            pan?.addTarget(self, action: #selector(handlePan))
         } else {
            pan?.removeTarget(self, action:nil)
         }
      }
   }
   
   weak var workspace: UIView!
   weak var currentPageView : UIView!
   weak var pan : UIPanGestureRecognizer?
   
   fileprivate var leftTag : TagViewController? {
      didSet{
         leftTag?.delegate = self
      }
   }
   fileprivate var rightTag : TagViewController? {
      didSet{
         rightTag?.delegate = self
      }
   }
   
   fileprivate var beforeViewController : UpViewController?
   fileprivate var nextViewController : UpViewController?
   
   fileprivate var _shouldUseLeftTag = false
   fileprivate var _shouldUseRightTag = false
   fileprivate var _shouldCreateNextViewController = false
   fileprivate var _shouldCreateBeforeViewController = false
   fileprivate var transitionBegan = false {
      didSet {
         delegate?.allowsUserInteraction?(!transitionBegan)
      }
   }

   fileprivate var velocity: CGFloat = 0
   
   fileprivate let tagWidthFraction : CGFloat = 0.25
   fileprivate let transitionThreshold : CGFloat = 0.3
   fileprivate let duration : Double = 0.4
}

extension PageDriver {

   @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
      switch gesture.state {
      case .began, .changed: panChanged(gesture)
      case .ended: panEnded(gesture)
      default: break
      }
   }
   
   fileprivate func panChanged(_ gesture: UIPanGestureRecognizer)
   {
      startTransition()
      
      let translationX = gesture.translation(in: workspace).x
      handleTranslation(at: translationX)
      
      updateTags(with: translationX)
   }

   fileprivate func panEnded(_ gesture: UIPanGestureRecognizer)
   {
      let translationInX = gesture.translation(in: workspace).x

      velocity = gesture.velocity(in: workspace).x
      
//      handleAnimation(at: translationInX)
      handleAnimation(at: translationInX, velocity: velocity)
   }
}

extension PageDriver {
   
   fileprivate func startTransition() {
      
      if !transitionBegan {
         transitionBegan = true
         setUpLogic()
         if _shouldUseLeftTag {
            leftTag = createleftTag()
            leftTag?.currentState = .pull
         }
         if _shouldUseRightTag {
            rightTag = createRightTag()
            rightTag?.currentState = .pull
         }
         if _shouldCreateBeforeViewController {
            beforeViewController = createBeforeViewController()
            delegate?.configure?(beforeViewController: beforeViewController!)
         }
         if _shouldCreateNextViewController {
            nextViewController = createNextViewController()
            delegate?.configure?(nextViewController: nextViewController!)
         }
      }
   }
   
   fileprivate func setUpLogic() {
      
      if let delegate = delegate {
         _shouldUseLeftTag = delegate.shouldUseLeftTag
         _shouldUseRightTag = delegate.shouldUseRightTag
         _shouldCreateBeforeViewController = delegate.shouldCreateBeforeViewController
         _shouldCreateNextViewController = delegate.shouldCreateNextViewController
      }
   }
   
   fileprivate func createleftTag() -> TagViewController? {
      let tagVC = TagViewController()
      let origin = workspace.frame.origin.applying(CGAffineTransform(translationX: -workspace.frame.width * tagWidthFraction, y: 0))
      let size = CGSize(width: workspace.frame.width*tagWidthFraction, height: workspace.frame.height)
      tagVC.view.frame = CGRect(origin: origin, size: size)
      workspace.addSubview(tagVC.view)
      return tagVC
   }
   
   fileprivate func createRightTag() -> TagViewController? {
      let tagVC = TagViewController()
      let origin = workspace.frame.origin.applying(CGAffineTransform(translationX: workspace.frame.width, y: 0))
      let size = CGSize(width: workspace.frame.width*tagWidthFraction, height: workspace.frame.height)
      tagVC.view.frame = CGRect(origin: origin, size: size)
      workspace.addSubview(tagVC.view)
      return tagVC
   }
   
   fileprivate func createBeforeViewController() -> UpViewController? {
      let vc = UpViewController()
      var origin = CGPoint.zero
      if _shouldUseLeftTag {
         origin = workspace.frame.origin.applying(CGAffineTransform(translationX: -workspace.frame.width*(1+tagWidthFraction), y: 0))
      } else {
         origin = workspace.frame.origin.applying(CGAffineTransform(translationX: -workspace.frame.width, y: 0))
      }
      vc.view.frame = CGRect(origin: origin, size: workspace.frame.size)
      workspace.addSubview(vc.view)
      return vc
   }
   
   fileprivate func createNextViewController() -> UpViewController? {
      let vc = UpViewController()
      var origin = CGPoint.zero
      if _shouldUseRightTag {
         origin = workspace.frame.origin.applying(CGAffineTransform(translationX: workspace.frame.width*(1+tagWidthFraction), y: 0))
      } else {
         origin = workspace.frame.origin.applying(CGAffineTransform(translationX: workspace.frame.width, y: 0))
      }
      vc.view.frame = CGRect(origin: origin, size: workspace.frame.size)
      workspace.addSubview(vc.view)
      return vc
   }
}

extension PageDriver {
   
   fileprivate func handleTranslation(at translationInX: CGFloat) {
      if translationInX > 0 {
         delegate?.movingToTheLeft?()
      }
      
      if translationInX <= 0 && _shouldUseRightTag {
         let resistance = log(abs(translationInX)+1)
         if resistance >= 2 {
            workspace.moveBy(x: 1.2 * translationInX / resistance)
         } else {
            workspace.moveBy(x: translationInX / 2)
         }
         
      } else if translationInX <= 0 && !_shouldCreateNextViewController {
         let resistance = log(abs(translationInX)+1)
         if resistance >= 2 {
            workspace.moveBy(x: 1.2 * translationInX / resistance)
         } else {
            workspace.moveBy(x: translationInX / 2)
         }
         
      } else if translationInX <= 0 && !_shouldUseRightTag && _shouldCreateNextViewController {
         workspace.moveBy(x: translationInX)
         
      } else if translationInX > 0 && _shouldCreateBeforeViewController && !_shouldUseLeftTag {
         workspace.moveBy(x: translationInX)
         
      } else if translationInX > 0 && _shouldUseLeftTag {
         let resistance = log(abs(translationInX)+1)
         if resistance >= 2 {
            workspace.moveBy(x: 1.2 * translationInX / resistance)
         } else {
            workspace.moveBy(x: translationInX / 2)
         }
         
      } else if translationInX > 0 && !_shouldCreateBeforeViewController {
         let resistance = log(abs(translationInX)+1)
         if resistance >= 2 {
            workspace.moveBy(x: 1.2 * translationInX / resistance)
         } else {
            workspace.moveBy(x: translationInX / 2)
         }
         
      }
   }
   
   fileprivate func updateTags(with translationX: CGFloat) {
      if let leftTag = leftTag {
         if _shouldUseLeftTag {
            if translationX >= tagWidthFraction * 2 * workspace.frame.width {
               leftTag.currentState = .release
            } else {
               leftTag.currentState = .pull
            }
         }
      }
      if let rightTag = rightTag {
         if _shouldUseRightTag {
            if translationX <= -tagWidthFraction * 2 * workspace.frame.width {
               rightTag.currentState = .release
            } else {
               rightTag.currentState = .pull
            }
         }
      }
   }
}

extension PageDriver {
   
   fileprivate func handleAnimation(at translationInX: CGFloat) {
      if translationInX <= -transitionThreshold * workspace.bounds.width && _shouldCreateNextViewController {
         delegate?.willMoveTo?(nextViewController: nextViewController!)
         animateMovingToNextViewController()
         
      }  else if translationInX <= 0 {
         animateMovingBackToCurrentController()
         
      } else if translationInX > transitionThreshold * workspace.bounds.width && _shouldCreateBeforeViewController {
         delegate?.willMoveTo?(beforeViewController: beforeViewController!)
         animateMovingToBeforeViewController()
         
      } else if translationInX > 0 {
         animateMovingBackToCurrentController()
      }
   }
   
   fileprivate func handleAnimation(at translationInX: CGFloat, velocity vX: CGFloat) {
      if translationInX <= -transitionThreshold * workspace.bounds.width && _shouldCreateNextViewController {
         delegate?.willMoveTo?(nextViewController: nextViewController!)
         animateMovingToNextViewController(velocity: vX)
         
      }  else if translationInX <= 0 {
         animateMovingBackToCurrentController()
         
      } else if translationInX > transitionThreshold * workspace.bounds.width && _shouldCreateBeforeViewController {
         delegate?.willMoveTo?(beforeViewController: beforeViewController!)
         animateMovingToBeforeViewController(velocity: vX)
         
      } else if translationInX > 0 {
         animateMovingBackToCurrentController()
      }
   }
}

extension PageDriver {
   
   fileprivate func animateMovingToNextViewController() {
      
      func animation() {
         if _shouldUseRightTag {
            workspace.moveBy(x: -workspace.width * (1 + tagWidthFraction))
            
         } else {
            workspace.moveBy(x: -workspace.width)
         }
      }
      
      func completion() {
         UIView.removeFromSuperviews(views: beforeViewController?.view, leftTag?.view, rightTag?.view)
         delegate?.copyData?(fromVC: self.nextViewController!)
         nextViewController?.view.removeFromSuperview()
         workspace.identity()
         transitionBegan = false
         delegate?.didMoveToNextViewController?()
      }
      
      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
         animation()
      }) { _ in
         completion()
      }
   }
   
   fileprivate func animateMovingToNextViewController(velocity vX: CGFloat) {
      
      func animation() {
         if _shouldUseRightTag {
            workspace.moveBy(x: -workspace.width * (1 + tagWidthFraction))
            
         } else {
            workspace.moveBy(x: -workspace.width)
         }
      }
      
      func completion() {
         UIView.removeFromSuperviews(views: beforeViewController?.view, leftTag?.view, rightTag?.view)
         delegate?.copyData?(fromVC: self.nextViewController!)
         nextViewController?.view.removeFromSuperview()
         workspace.identity()
         transitionBegan = false
         delegate?.didMoveToNextViewController?()
      }

      UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: vX / workspace.width, options: .curveLinear, animations: {
         animation()
      }, completion: { _ in
         completion()
      })
   }
}


extension PageDriver {

   fileprivate func animateMovingBackToCurrentController() {
      
      func animation() {
         workspace.identity()
      }
      
      func completion() {
         UIView.removeFromSuperviews(views: beforeViewController?.view, nextViewController?.view, leftTag?.view, rightTag?.view)
         transitionBegan = false
         delegate?.didMoveBackToViewController?()
      }
      
      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
         animation()
      }) { _ in
         completion()
      }
   }
}

extension PageDriver {

   fileprivate func animateMovingToBeforeViewController() {
      
      func animation() {
         if _shouldUseLeftTag {
            workspace.moveBy(x: workspace.width * (1 + tagWidthFraction))

         } else {
            workspace.moveBy(x: workspace.width)
         }
      }
      
      func completion() {
         UIView.removeFromSuperviews(views: nextViewController?.view, leftTag?.view, rightTag?.view)
         delegate?.copyData?(fromVC: self.beforeViewController!)
         beforeViewController?.view.removeFromSuperview()
         workspace.identity()
         transitionBegan = false
         delegate?.didMoveToBeforeViewController?()
      }
      
      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
         animation()
         })
      { _ in
         completion()
      }
   }
   
   fileprivate func animateMovingToBeforeViewController(velocity vX: CGFloat) {
      
      func animation() {
         if _shouldUseLeftTag {
            workspace.moveBy(x: workspace.width * (1 + tagWidthFraction))
            
         } else {
            workspace.moveBy(x: workspace.width)
         }
      }
      
      func completion() {
         UIView.removeFromSuperviews(views: nextViewController?.view, leftTag?.view, rightTag?.view)
         delegate?.copyData?(fromVC: self.beforeViewController!)
         beforeViewController?.view.removeFromSuperview()
         workspace.identity()
         transitionBegan = false
         delegate?.didMoveToBeforeViewController?()
      }
      
      UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: vX / workspace.width, options: .curveLinear, animations: {
         animation()
      }, completion: { _ in
         completion()
      })
   }
}


extension PageDriver {

   func labelTextFor(state:TagViewController.state) -> String {
      switch state{
      case.pull: return tagPulled
      case.release: return tagReleased
      }
   }

   func removeComplementaryViews() {
      transitionBegan = false
      UIView.removeFromSuperviews(views: beforeViewController?.view, nextViewController?.view, leftTag?.view, rightTag?.view)
   }
   
   func resetPosition() {
      workspace.identity()
      workspace.frame.origin.x = 0
   }
}

@objc protocol PageDriverDelegate : class
{
   var shouldCreateBeforeViewController : Bool { get }
   var shouldCreateNextViewController : Bool { get }
   var shouldUseRightTag : Bool { get }
   var shouldUseLeftTag : Bool { get }
   
   @objc optional func configure(beforeViewController: UIViewController)
   @objc optional func configure(nextViewController: UIViewController)
   
   @objc optional func willMoveTo(nextViewController: UIViewController)
   @objc optional func willMoveTo(beforeViewController: UIViewController)
   
   @objc optional func didMoveToBeforeViewController()
   @objc optional func didMoveToNextViewController()
   
   @objc optional func didMoveBackToViewController()
   
   @objc optional func movingToTheLeft()
   
   @objc optional func copyData(fromVC: UIViewController)
   @objc optional func allowsUserInteraction(_ bool: Bool)
}
