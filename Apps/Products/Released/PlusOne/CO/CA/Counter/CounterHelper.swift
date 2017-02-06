
import UIKit

class CounterHelper: NSObject
{
    weak var stepper: StepperDriver!
    weak var stepperSound: StepperSoundDriver!
    weak var counter: CounterDriver!
    
    var timerSettings: [SMStepperSpeed : (range: CountableRange<Int>, timer: Double)?] = [
        SMStepperSpeed.normal : (0..<5,0.5),
        SMStepperSpeed.fast : (5..<15,0.2),
        SMStepperSpeed.faster : (15..<50,0.1),
        SMStepperSpeed.fastest : (50..<1000,0.03)
    ]
    
    var stepperSoundTimerSettings: [SoundSpeed : (range: CountableRange<Int>, timer: Double)?] = [
        SoundSpeed.normal : (0..<5,0.5),
        SoundSpeed.fast : (5..<15,0.2),
        SoundSpeed.faster : (15..<50,0.1)
    ]
}

extension CounterHelper {
   func setupController() {
      stepper.delegate = self
      stepperSound.delegate = self
   }
}

extension CounterHelper: StepperDriverDelegate, SoundDriverDelegate {
   
    func stepperDidChange(to value: Int) {
      counter.set(count: value)
   }
}
