
import UIKit

class PageHelper : NSObject
{
   weak var page : PageDriver!
   
   weak var stepper: StepperDriver!
   weak var stepperSound: StepperSoundDriver!
   weak var menu: TransitionDriver!
   weak var shop: ShopDriver!
   weak var counterDriver: CounterDriver!
   
   lazy var limitIndex: Int = {
      if comprado {
         return 10000
      } else {
         return 5
      }
   }()
   
   var index : Int = 0 {
      didSet {
         if index == 0 {
            menu.isActive = true
         } else {
            menu.isActive = false
         }
      }
   }
   
   lazy var _counter: Counter = { [unowned self] in
      let counter = counters[self.index]
      return counter
      }()
   
   // MARK: PageDriverDelegate
   var shouldCreateBeforeViewController: Bool {
      if index <= 0 {
         return false
      } else {
         return true
      }
   }
   var shouldCreateNextViewController: Bool {
      if index < limitIndex {
         return true
      } else {
         return false
      }
   }
   var shouldUseRightTag: Bool {
      if index == limitIndex || index < counters.count - 1 {
         return false
      } else if index != limitIndex && index == counters.count - 1 {
         return true
      } else {
         return false
      }
   }
   var shouldUseLeftTag: Bool = false
}

extension PageHelper {
   
   func setupController() {
      page.delegate = self
      counterDriver.delegate = self
   }
}

extension PageHelper : PageDriverDelegate {
   
   func configure(beforeViewController: UIViewController) {
      if shouldCreateBeforeViewController {
         if let beforeViewController = beforeViewController as? UpViewController {
            let counter = counters[index - 1]
            beforeViewController.counterDriver.set(counter: counter)
         }
      }
   }
   
   func configure(nextViewController: UIViewController) {
      if shouldCreateNextViewController {
         if let nextViewController = nextViewController as? UpViewController {
            if index < counters.count - 1 {
               let counter = counters[index + 1]
               nextViewController.counterDriver.set(counter: counter)
            } else {
               let counter = Counter.random()
               nextViewController.counterDriver.set(counter: counter)
            }
         }
      }
   }
   
   func willMoveTo(beforeViewController: UIViewController) {
      counters[index].count = counterDriver.get().count
      counters[index].text = counterDriver.get().text
      index -= 1
   }
   
   func willMoveTo(nextViewController: UIViewController) {
      counters[index].count = counterDriver.get().count
      counters[index].text = counterDriver.get().text
      if index == counters.count - 1 {
         if let vc = nextViewController as? UpViewController {
            let counter = Counter.random()
            vc.counterDriver.set(counter: counter)
            counters.append(counter)
         }
      }
      index += 1
      setStepper()
   }
   
   func movingToTheLeft() {
      if index == 0 {
         page.resetPosition()
         menu.isActive = true
      }
   }
   
   func copyData(fromVC: UIViewController) {
      let fromVC = fromVC as! UpViewController
      counterDriver.set(counter: (fromVC.counterDriver.get()))
   }
   
   func allowsUserInteraction(_ bool: Bool) {
      if bool {
         stepper.isActive = true
         stepperSound.isActive = true
      } else {
         stepper.isActive = false
         stepperSound.isActive = false
      }
   }
   
   func didMoveToBeforeViewController() {
      shop.isActive = false
      counterDriver.resetButton?.isHidden = true
      counterDriver.resetButton?.alpha = 0.0
      setStepper()
   }
   
   func didMoveToNextViewController() {
      if index == limitIndex {
         if !comprado {
            shop.isActive = true
            counterDriver.set(counter: counters[index])
            counterDriver.resetButton?.isHidden = true
            counterDriver.resetButton?.alpha = 0.0
         }
      }
      setStepper()
   }
   
   func didMoveBackToViewController() {
      if index == limitIndex {
         shop.isActive = true
      }
      setStepper()
   }
}

extension PageHelper : CounterDriverDelegate {

   func counterChanged() {
      let someCounter = counterDriver.get()
      counters[index] = someCounter
      setStepper()
   }
}

extension PageHelper {
   
   fileprivate func setStepper() {
      let value = counters[index].count
      stepper.value = value
      stepperSound.value = value
   }
}
