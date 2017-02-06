

import UIKit

class TagViewController: UIViewController {
 
   weak var delegate: TagViewControllerDelegate?
   
   lazy var tagLabel : UILabel = {
      let t = UILabel()
      t.textAlignment = .center
      t.textColor = .white
      t.font = UIFont.init(name: myTextFontBold, size: 24)
      t.transform = CGAffineTransform(rotationAngle:CGFloat(M_PI_2))
      return t
   }()
   
   var currentState: state! {
      didSet {
         tagLabel.text = delegate?.labelTextFor(state: currentState)
         if delegate == nil { tagLabel.text = currentState.rawValue
         }
      }
   }
   
   enum state: String {
      case pull = "pull to add"
      case release = "release to add"
   }
}

extension TagViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   private func setupViews() {
      view.addSubview(tagLabel)
      
      Constraint.make(tagLabel, .centerX, .equal, view, .centerX, 1, -10)
      Constraint.make(tagLabel, .centerY, .equal, view, .centerY, 1, 0)
   }
}

protocol TagViewControllerDelegate : class
{
   func labelTextFor(state: TagViewController.state) -> String
}

