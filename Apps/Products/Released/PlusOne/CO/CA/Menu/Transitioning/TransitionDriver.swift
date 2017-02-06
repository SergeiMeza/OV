
import SMKit


class TransitionDriver: UIPercentDrivenInteractiveTransition {
   
   weak var page: PageDriver!
   weak var view: UIView?
   weak var pan: UIPanGestureRecognizer?
   
   var menuViewController: MenuViewController { return MenuViewController() }
   // var logoViewController: LogoViewController { return LogoViewController() }
   
   var navigationController : UINavigationController? {
      didSet {
         navigationController?.delegate = self
      }
   }
   
   enum currentViewController {
      case app, menu, logo
   }
   
   var current = currentViewController.app
   
   var operation = UINavigationControllerOperation.push
   
   
   var isActive = true {
      didSet{
         if isActive {
            page.isActive = false
            pan?.removeTarget(nil, action: nil)
            pan?.addTarget(self, action: #selector(panned))
            pan?.addTarget(self, action: #selector(pannedInteractive))
         } else {
            pan?.removeTarget(nil, action: nil)
            page.isActive = true
         }
      }
   }
   
   fileprivate var didTransitionBegan = false
   fileprivate var shouldCompleteTransition = false
   fileprivate var completionSeed: CGFloat {
      return (1 - percentComplete)
   }
}

extension TransitionDriver {

   @objc fileprivate func panned(g: UIPanGestureRecognizer) {

      let translationX = g.translation(in: g.view!).x
      if g.state == .began || g.state == .changed {
         guard translationX != 0.0 else { return }
         handleTranslation(at: translationX, g: g)
      }
      
      if g.state == .ended || g.state == .cancelled {
         didTransitionBegan = false
      }
   }
   
   fileprivate func handleTranslation(at translationX: CGFloat, g: UIPanGestureRecognizer) {
      if !didTransitionBegan {
         didTransitionBegan = true
         
         if current == .app {
            if view?.frame.origin.x != 0 {
               view?.transform = CGAffineTransform.identity
               view?.frame.origin.x = 0
            }
         
            if translationX < 0 {
               pan?.removeTarget(nil, action: nil)
               page.isActive = true
               didTransitionBegan = false
               
            } else if translationX >= 0 {
               page.isActive = false
               pan?.addTarget(self, action: #selector(panned))
               
               navigationController?.pushViewController(menuViewController, animated: true)
               page.removeComplementaryViews()
            }
         }
         
         if current == .menu {
            if translationX > 0 {
               let vc = OVAboutViewController01()
               vc.hideCloseButton = true
               navigationController?.pushViewController(vc, animated: true)
               // navigationController?.pushViewController(logoViewController, animated: true)
            }
            if translationX < 0 {
               _ = navigationController?.popViewController(animated: true)
            }
         }
         
         if current == .logo {
            if translationX < 0 {
               _ = navigationController?.popViewController(animated: true)
            }
         }
      }
      
      
   }
}

extension TransitionDriver: UINavigationControllerDelegate {
   
   func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.operation = operation
      return self
   }
   
   func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return self
   }
   
   func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      
      if viewController is AppViewController {
         current = .app
      }
      
      if viewController is MenuViewController {
         current = .menu
      }
      
      if viewController is OVAboutViewController01 {
         current = .logo
      }
      
      if viewController is AppViewController {
         pan?.view?.removeGestureRecognizer(pan!)
         view?.addGestureRecognizer(pan!)
      }
      
      if !(viewController is AppViewController) {
         pan?.view?.removeGestureRecognizer(pan!)
         viewController.view.addGestureRecognizer(pan!)
      }
   }
}

extension TransitionDriver: UIViewControllerAnimatedTransitioning {

   func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.5
   }
   
   func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      if operation == .push {
         
         let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
         let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
         let finalFrameForVC = transitionContext.finalFrame(for: toVC)
         let containerView = transitionContext.containerView
         let bounds = containerView.bounds
         
         toVC.view.frame = finalFrameForVC.offsetBy(dx: -bounds.size.width, dy: 0)
         containerView.addSubview(toVC.view)
         
         UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.frame = finalFrameForVC
            fromVC.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
         }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
         }
         
         
      } else if operation == .pop {
         
         let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
         let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
         let finalFrameForVC = transitionContext.finalFrame(for: toVC)
         let containerView = transitionContext.containerView
         let bounds = containerView.bounds
         
         toVC.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
         containerView.addSubview(toVC.view)
         
         UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromVC.view.frame = finalFrameForVC.offsetBy(dx: -bounds.width, dy: 0)
            toVC.view.frame = finalFrameForVC
            
         }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
         }
      }
   }
}

extension TransitionDriver {

   @objc func pannedInteractive(g: UIPanGestureRecognizer) {   
      let translationX = g.translation(in: g.view!).x
      let width = g.view!.bounds.width
      
      switch g.state {
      case .changed:
         let c = CGFloat(fminf(fmaxf(Float(abs(translationX) / width), 0.0), 1.0))
         shouldCompleteTransition = c > 0.35
         update(c)
      case .cancelled, .ended:
         if !shouldCompleteTransition || g.state == .cancelled {
            cancel()
         } else {
            finish()
         }
      default: break
      }
   }
}

