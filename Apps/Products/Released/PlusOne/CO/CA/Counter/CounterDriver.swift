
import UIKit

// done

class CounterDriver: NSObject {
   
   weak var delegate : CounterDriverDelegate?
   
   weak var upVC: UpViewController? {
      didSet {
         setupController()
      }
   }
   
   weak var view: UIView?
   weak var label : UILabel?
   weak var textfield: UITextField?
   weak var resetButton: UIButton?
   
   var isUserInteractionEnabled = true {
      didSet {
         if isUserInteractionEnabled {
            textfield?.isUserInteractionEnabled = true
         } else {
            textfield?.isUserInteractionEnabled = false
         }
      }
   }
}

extension CounterDriver {
   
   fileprivate func setupController() {
      self.view = upVC?.view
      self.label = upVC?.label
      self.textfield = upVC?.textfield
      self.resetButton = upVC?.button
      
      textfield?.delegate = self
      resetButton?.alpha = 0
      resetButton?.addTarget(self, action: #selector(resetCount), for: .touchDown)
   }
}


extension CounterDriver {
   
   @objc fileprivate func resetCount() {
      set(count: 0)
      delegate?.counterChanged()
   }
}

extension CounterDriver {
   
   open func set(count: Int) {
      updateButton(withCount: count)
      
      self.label?.text = "\(count)"
      delegate?.counterChanged()
   }
}

extension CounterDriver {

   fileprivate func updateButton(withCount count: Int) {
      if count == 0 {
         if let resetButton = resetButton {
            resetButton.fadeOut()
            
         }
      } else {
         if let resetButton = resetButton {
            resetButton.fadeIn()
         }
      }
   }
}

extension CounterDriver : UITextFieldDelegate {
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textfield?.text = textField.text
      delegate?.counterChanged()
      textField.resignFirstResponder()
      return true
   }
}

extension CounterDriver {
   
   open func set(counter: Counter) {
      view?.backgroundColor = counter.properties.color
      label?.text = "\(counter.properties.count)"
      textfield?.text = counter.properties.text
      
      let color = counter.properties.color
      
      var white: CGFloat = 0
      
      color.getWhite(&white, alpha: nil)
      
      if white >= 0.7 {
         textfield?.textColor = UIColor.init(white: 0.2, alpha: 0.5)
      } else {
         textfield?.textColor = UIColor.init(white: 1, alpha: 0.5)
      }
      
      delegate?.counterChanged()
   }
   
   open func set(color: UIColor, count: Int, text: String?) {
      view?.backgroundColor = color
      updateButton(withCount: count)
      self.label?.text = "\(count)"
      textfield?.text = text
      delegate?.counterChanged()
   }
   
   func get() -> Counter {
      if let count = label, let countView = view, let countLabel = textfield {
         if let number = NumberFormatter().number(from: count.text!)?.intValue {
            return Counter(color: countView.backgroundColor!, text: countLabel.text, count: number)
         }
      }
      if let countView = view, let countLabel = textfield {
         return Counter(color: countView.backgroundColor!, text: countLabel.text, count: 0)
      }
      
      return Counter.init(color: .black, text: "UNICORNS", count: 0)
   }
}

protocol CounterDriverDelegate : class
{
   func counterChanged()
}

