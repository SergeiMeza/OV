
import UIKit
import AudioToolbox

class StepperDriver: NSObject {
   
   weak var delegate : StepperDriverDelegate?
   
   weak var plusButton: UIButton?
   weak var minusButton: UIButton?
   
   var isActive = true {
      didSet {
         if isActive {
            setupButtons()
         } else {
            unsetButtons()
         }
         plusButton?.backgroundColor = .unselectedButtonColor
         minusButton?.backgroundColor = .unselectedButtonColor
      }
   }

   var value = 0 {
      didSet {
         if value <= minimum {
            value = minimum
            resetTimer()
         } else if value >= maximum {
            value = maximum
         }
      }
   }
   
   fileprivate let step = 1
   fileprivate let minimum = 0
   fileprivate let maximum = 99999
   fileprivate let repeats = true
   
   fileprivate var timer : Timer?
   fileprivate var currentTimerSetting: (range:CountableRange<Int>,timer:Double)?
   fileprivate var timerFireCount = 0
   
   fileprivate enum State {
      case iddle, increase, decrease
   }
   
   deinit {
      timer?.invalidate()
      timer = nil
   }
   
   fileprivate var stepperSpeed : SMStepperSpeed? {
      didSet {
         if let stepperSpeed = stepperSpeed {
            if stepperSpeed != .normal {
               timer?.invalidate()
               timer = nil
               addTimer(delegate?.timerSettings[stepperSpeed]??.timer)
            }
         }
      }
   }
   
   fileprivate var stepperState = State.iddle {
      didSet {
         guard stepperState != .iddle else{
            return
         }
         // update value (+1 or -1)
         updateValue()
         stepperSpeed = .normal
         if repeats {
            addTimer(delegate?.timerSettings[.normal]??.timer)
         }
      }
   }
}


extension StepperDriver {
   
   fileprivate func setupButtons() {
      plusButton?.addTarget(self, action: #selector(plusButtonTouchedDown), for: .touchDown)
      plusButton?.addTarget(self, action: #selector(plusButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
      minusButton?.addTarget(self, action: #selector(minusButtonTouchedDown), for: .touchDown)
      minusButton?.addTarget(self, action: #selector(minusButtonTouchedUp), for:[.touchUpInside, .touchUpOutside])
   }
   
   fileprivate func unsetButtons() {
      plusButton?.removeTarget(self, action: nil, for: [.touchDown, .touchUpInside, .touchUpOutside])
      minusButton?.removeTarget(self, action: nil, for: [.touchDown, .touchUpInside, .touchUpOutside])
   }
}

extension StepperDriver {
   
   @objc fileprivate func plusButtonTouchedDown(_ sender: UIButton) {
      plusButton?.isEnabled = false
      plusButton?.bg = .selectedButtonColor
      resetTimer()
      if value != maximum {
         stepperState = .increase
      }
   }
   
   @objc fileprivate func plusButtonTouchedUp(_ sender: UIButton) {
      plusButton?.isEnabled = true
      plusButton?.bg = .unselectedButtonColor
      reset()
   }
   
   @objc fileprivate func minusButtonTouchedDown(_ sender: UIButton) {
      minusButton?.isEnabled = false
      minusButton?.bg = .selectedButtonColor
      resetTimer()
      if value != minimum {
         stepperState = .decrease
      }
   }
   
   @objc fileprivate func minusButtonTouchedUp(_ sender: UIButton) {
      minusButton?.isEnabled = true
      minusButton?.bg = .unselectedButtonColor
      reset()
   }
   
   @objc fileprivate func reset() {
      stepperState = .iddle
      stepperSpeed = .normal
      resetTimer()
   }
   
   @objc fileprivate func resetTimer() {
      if let timer = timer {
         timer.invalidate()
         self.timer = nil
         timerFireCount = 0
      }
   }
}

extension StepperDriver {

   fileprivate func addTimer(_ interval: Double?) {
      guard let interval = interval else{
         fatalError()
      }
      timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
   }
   
   @objc private func timerFired(sender: Timer) {
      timerFireCount += 1
      updateValue()
      let range = delegate?.timerSettings[stepperSpeed!]??.range
      guard let rangeNotNil = range else {fatalError()}
      if !rangeNotNil.contains(timerFireCount) {
         switch stepperSpeed! {
         case .normal: stepperSpeed! = .fast
         case .fast: stepperSpeed! = .faster
         case .faster: stepperSpeed! = .fastest
         case .fastest: break
         }
      }
   }
   
   fileprivate func updateValue() {
      if stepperState == .increase {
         value += step
      } else if stepperState == .decrease {
         value -= step
      }
      didChangeValue(to: value)
   }
   
   fileprivate func didChangeValue(to value: Int) {
      delegate?.stepperDidChange(to: value)
   }
}

enum SMStepperSpeed {
   case normal, fast, faster, fastest
}

protocol StepperDriverDelegate : class
{
   var timerSettings : [SMStepperSpeed : (range : CountableRange<Int>, timer : Double)?] { get set }
   func stepperDidChange(to value: Int)
}

extension UIColor {
   static var unselectedButtonColor: UIColor { return UIColor.init(white: 0.98, alpha: 1) }
   static var selectedButtonColor: UIColor { return UIColor.init(white: 0.93, alpha: 1) }
}
