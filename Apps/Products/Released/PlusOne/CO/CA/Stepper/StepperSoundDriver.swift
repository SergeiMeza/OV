
import UIKit
import AudioToolbox

class StepperSoundDriver: NSObject {
   
   weak var delegate : SoundDriverDelegate?
   
   weak var plusButton: UIButton?
   weak var minusButton: UIButton?
   
   var isActive = true {
      didSet {
         if isActive {
            setupButtons()
         } else {
            unsetButtons()
         }
      }
   }
   
   var value = 0 {
      didSet {
         if value <= minimum {
            value = minimum
            reset()
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
   
   deinit {
      timer?.invalidate()
      timer = nil
   }

   fileprivate enum State {
      case iddle, increase, decrease
   }
   
   fileprivate var stepperSpeed : SoundSpeed? {
      didSet {
         if let stepperSpeed = stepperSpeed {
            if stepperSpeed != .normal {
               timer?.invalidate()
               timer = nil
               addTimer(delegate?.stepperSoundTimerSettings[stepperSpeed]??.timer)
            }
         }
      }
   }
   
   fileprivate var stepperState = State.iddle {
      didSet {
         guard stepperState != .iddle else {
            return
         }
         // update value (+1 or -1)
         playSound()
         updateValue()
         stepperSpeed = .normal
         if repeats {
            addTimer(delegate?.stepperSoundTimerSettings[.normal]??.timer)
         }
      }
   }
}

extension StepperSoundDriver {
   
   func setupButtons() {
      plusButton?.addTarget(self, action: #selector(plusTouch), for: .touchDown)
      minusButton?.addTarget(self, action: #selector(minusTouch), for: .touchDown)
      plusButton?.addTarget(self, action: #selector(reset), for: [.touchUpInside,.touchUpOutside])
      minusButton?.addTarget(self, action: #selector(reset), for: [.touchUpInside,.touchUpOutside])
   }
   
   func unsetButtons() {
      plusButton?.removeTarget(self, action: nil, for: [.touchDown,.touchUpInside,.touchUpOutside])
      minusButton?.removeTarget(self, action: nil, for: [.touchDown,.touchUpInside,.touchUpOutside])
   }
}

extension StepperSoundDriver {
   
   @objc fileprivate func plusTouch(_ sender: UIButton) {
      resetTimer()
      if value != maximum {
         stepperState = .increase
      }
   }
   
   @objc fileprivate func minusTouch(_ sender: UIButton) {
      resetTimer()
      stepperState = .decrease
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

extension StepperSoundDriver {
   
   fileprivate func addTimer(_ interval: Double?) {
      guard let interval = interval else {fatalError()}
      timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
   }
   
   @objc fileprivate func timerFired(sender: Timer) {
      timerFireCount += 1
      playSound()
      updateValue()
      let range = delegate?.stepperSoundTimerSettings[stepperSpeed!]??.range
      guard let rangeNotNil = range else {
         fatalError()
      }
      if !rangeNotNil.contains(timerFireCount) {
         switch stepperSpeed! {
         case .normal: stepperSpeed! = .fast
         case .fast: stepperSpeed! = .faster
         case .faster: break
         }
      }
   }
   
   fileprivate func playSound() {
      if stepperState == .increase {
         AudioServicesPlaySystemSound(addSound)
      } else if stepperState == .decrease {
         if value >= 1 {
            AudioServicesPlaySystemSound(minusSound)
         } else {
            AudioServicesPlaySystemSound(zeroSound)
         }
      }
   }
   
   fileprivate func updateValue() {
      if stepperState == .increase {
         value += step
      } else if stepperState == .decrease {
         value -= step
      }
   }
}

enum SoundSpeed {
   case normal, fast, faster
}

protocol SoundDriverDelegate : class
{
   var stepperSoundTimerSettings : [SoundSpeed : (range : CountableRange<Int>,timer : Double)?] { get set }
}
