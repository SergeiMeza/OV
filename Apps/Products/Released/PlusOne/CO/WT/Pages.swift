import UIKit

class Page0 : PageViewController {
   
   lazy var label: SMLabel = { [unowned self] in
      let s = NSMutableAttributedString()
      s.append("Welcome to ", size: self.view.height/32, weight: UIFontWeightRegular)
      s.append("PlusOne", size: self.view.height/32, weight: UIFontWeightBold)
      s.add(lines: 2)
      s.append("Tap or swipe ", size: self.view.height/40, weight: UIFontWeightBold)
      s.append("Tap or swipe ", size: self.view.height/40, weight: UIFontWeightLight)
      let l = SMLabel()
      l.attributedText = s
      return l
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   } // done
   
   func setupViews() {
      view.addSubviews(label)
      
      let metrics = ["tvW": view.width-98]
      
      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: label)
      Constraint.center(label)
   } // done
} // done

class Page1: PageViewController {
   
   lazy var label: SMLabel = { [unowned self] in
      let s = NSMutableAttributedString()
      s.append("PlusOne allows you to count ", size: self.view.height/40, weight: UIFontWeightLight)
      s.append("unlimited items!", size: self.view.height/40, weight: UIFontWeightBold)
      let l = SMLabel()
      l.attributedText = s
      return l
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   } // done
   
   func setupViews() {
      view.addSubviews(label)
      
      let metrics = ["tvW": view.width-98]
      
      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: label)
      Constraint.center(label, mX: 1, mY: 0.5, cX: 0, cY: 0)
   } // done
} // done

class Page2: PageViewController {
   
   lazy var label: SMLabel = {[unowned self] in
      let s = NSMutableAttributedString()
      s.append("Drag from the edge ", size: self.view.height/40, weight: UIFontWeightBold)
      s.append("to see your counter options.", size: self.view.height/40, weight: UIFontWeightLight)
      let l = SMLabel()
      l.attributedText = s
      return l
   }()

   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   func setupViews() {
      view.addSubviews(label)
      
      let metrics = ["tvW": view.width-98]
      
      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: label)
      Constraint.center(label, mX: 1, mY: 0.5, cX: 0, cY: 0)
   }
} // done

class Page3: PageViewController {
   
   lazy var label: SMLabel = { [unowned self] in
      let s = NSMutableAttributedString()
      s.append("Swipe to the left or right ", size: self.view.height/40, weight: UIFontWeightBold)
      s.append("to move to a new counter.", size: self.view.height/40, weight: UIFontWeightLight)
      let l = SMLabel()
      l.attributedText = s
      return l
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   func setupViews() {
      view.addSubviews(label)
      
      let metrics = ["tvW": view.width-90]
      
      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: label)
      Constraint.center(label, mX: 1, mY: 0.5, cX: 0, cY: 0)
   }
} // done

class Page4: PageViewController {
   
   lazy var label: SMLabel = { [unowned self] in
      let s = NSMutableAttributedString()
      s.append("Touch the corner ", size: self.view.height/40, weight: UIFontWeightBold)
      s.append("to easily reset the count to 0.", size: self.view.height/40, weight: UIFontWeightLight)
      let l = SMLabel()
      l.attributedText = s
      return l
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   func setupViews() {
      view.addSubviews(label)
      
      let metrics = ["tvW": view.width-95]
      
      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: label)
      Constraint.center(label, mX: 1, mY: 0.5, cX: 0, cY: 0)
   }
}

protocol PageDelegate: class {
   func moveToNextPage()
   func finalizeTutorial()
}

class Page5: PageViewController {
   
   weak var delegate: PageDelegate?
   
   lazy var label: SMLabel = { [unowned self] in
      let s = NSMutableAttributedString()
      s.append("Sign up to the newsletter, and unlock new themes", size: self.view.height/40, weight: UIFontWeightLight)
      let l = SMLabel()
      l.attributedText = s
      return l
   }()
   
   let imageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      iv.isUserInteractionEnabled = false
      iv.image = #imageLiteral(resourceName: "mail")
      return iv
   }()
   
   let stackViewH: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.alignment = .center
      sv.spacing = 20
      sv.distribution = .fillEqually
      return sv
   }()
   
   lazy var button1: SMButton = { [unowned self] in
      let b = SMButton()
      b.setTitle("Skip", for: .normal)
      b.titleLabel?.font = UIFont.systemFont(ofSize: self.view.height/40, weight: UIFontWeightLight)
      b.setTitleColor(UIColor._black, for: .normal)
      b.addTarget(self, action: #selector(endTutorial), for: [.touchUpInside, .touchUpOutside])
      return b
   }()
   
   lazy var button2: SMButton = { [unowned self] in
      let b = SMButton()
      b.setTitle("Join", for: .normal)
      b.titleLabel?.font = UIFont.systemFont(ofSize: self.view.height/40, weight: UIFontWeightLight)
      b.setTitleColor(UIColor._black, for: .normal)
      b.addTarget(self, action: #selector(subscribe), for: [.touchUpInside, .touchUpOutside])
      return b
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
   }
   
   func setupViews() {
      view.addSubviews(label, imageView, stackViewH)
      stackViewH.addArrangedSubviews(button1, button2)
      
      setupConstraints()
   }
   
   func setupConstraints() {
      let metrics = ["tvW": view.width-98, "ivw": view.width*0.55, "svw": view.width * 0.7]
      
      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: label)
      Constraint.center(label, mX: 1, mY: 0.6, cX: 0, cY: 0)
      
      Constraint.make("H:[v0(ivw)]", metrics: metrics, views: imageView)
      Constraint.center(imageView, mX: 1, mY: 0.95, cX: 0, cY: 0)
      Constraint.make(imageView, .width, .equal, imageView, .height, (122/84), 0)
      
      Constraint.make("H:[v0(svw)]", metrics: metrics, views: stackViewH)
      Constraint.center(stackViewH, mX: 1, mY: 1.4, cX: 0, cY: 0)
   }
   
   func endTutorial() {
      delegate?.finalizeTutorial()
   }
   
   var subscribeVC = UIAlertController()
   
   @objc fileprivate func subscribe() {
      
      subscribeVC = UIAlertController.init(title: "", message: "Get the latest updates about our apps", preferredStyle: .alert)
      let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
      let subscribeAction = UIAlertAction.init(title: "Subscribe", style: .default, handler: { [unowned self] action in
         if let mail = self.subscribeVC.textFields?[0].text {
            userMail = mail
            self.presentAlert("Thanks! Your email address has been added to our list.")
            self.endTutorial()
         }
      })
      
      subscribeVC.addTextField { (textfield) in
         textfield.placeholder = "me@example.com"
         textfield.keyboardType = .emailAddress
      }
      
      subscribeVC.addAction(cancelAction)
      subscribeVC.addAction(subscribeAction)
      
      
      present(subscribeVC, animated: true, completion: nil)
   }
}

class SMLabel: UILabel {
   init() {
      super.init(frame: .zero)
      numberOfLines = 0
      lineBreakMode = .byWordWrapping
      textAlignment = .center
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

class SMButton: UIButton {

   init() {
      super.init(frame: .zero)
      let v = UIView()
      tintColor = ._black
      insertSubview(v, at: 0)
      backgroundColor = .clear
      layer.cornerRadius = 5
      layer.borderWidth = 1
      layer.borderColor = UIColor(white: 0.5, alpha: 1).cg
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

class SMTextField: UITextField {
   
   init() {
      super.init(frame: .zero)
      borderStyle = .none
      layer.borderColor = UIColor(white: 0.5, alpha: 1).cg
      layer.cornerRadius = 5
      layer.borderWidth = 1
      keyboardType = .emailAddress
   }
   
   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 8, dy: 0)
   }
   
   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 8, dy: 0)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}















































//class Page5: PageViewController {
//
//   weak var delegate: PageDelegate?
//
//   let textView: UITextView = {
//      let s = NSMutableAttributedString()
//      s.append("Use ", size: .title, weight: .regular)
//      s.appendBold("iCloud", size: .title)
//      s.append("?", size: .title, weight: .regular)
//      s.add(lines: 2)
//      s.append("Storing your lists in iCloud allows \nyou to keep your data in sync \nacross your iPhone, iPad and Mac.", size: .body, weight: .light)
//      let tv = UITextView()
//      tv.attributedText = s
//      tv.isEditable = false
//      tv.isUserInteractionEnabled = false
//      return tv
//   }()
//
//   let imageView: UIImageView = {
//      let iv = UIImageView()
//      iv.contentMode = .scaleAspectFit
//      iv.isUserInteractionEnabled = false
//      iv.image = #imageLiteral(resourceName: "page6")
//      return iv
//   }()
//
//   let stackView: UIStackView = {
//      let sv = UIStackView()
//      sv.axis = .horizontal
//      sv.backgroundColor = .red
//      sv.alignment = .fill
//      sv.spacing = 20
//      sv.distribution = .fillEqually
//      return sv
//   }()
//
//
//   let button1: UIButton = {
//      let b = UIButton(type: .system)
//      b.backgroundColor = .clear
//      b.layer.cornerRadius = 5
//      b.layer.borderWidth = 1
//      b.layer.borderColor = UIColor(white: 0.5, alpha: 1).cg
//      let s = MutableString()
//      s.appendLight("Not Now", size: .body)
//      b.setAttributedTitle(s, for: UIControlState())
//      b.setTitleColor(UIColor.textBlack, for: UIControlState())
//      return b
//   }()
//
//   let button2: UIButton = {
//      let b = UIButton(type: UIButtonType.roundedRect)
//      b.backgroundColor = .clear
//      b.layer.cornerRadius = 5
//      b.layer.borderWidth = 1
//      b.layer.borderColor = UIColor(white: 0.5, alpha: 1).cg
//      let s = MutableString()
//      s.appendBold("Use iCloud", size: .body)
//      b.setAttributedTitle(s, for: UIControlState())
//      b.setTitleColor(UIColor.textBlack, for: UIControlState())
//      return b
//   }()
//
//   override func viewDidLoad() {
//      super.viewDidLoad()
//      setupViews()
//      setupButtons()
//   }
//
//   func setupViews() {
//      view.addSubviews(textView, imageView, stackView)
//
//      let metrics = ["tvW": view.width-98, "tvH": 132, "ivw": view.width*0.55, "svw": view.width * 0.7]
//
//      Constraint.make("H:[v0(tvW)]", metrics: metrics, views: textView)
//      Constraint.make("V:[v0(tvH)]", metrics: metrics, views: textView)
//      Constraint.make(textView, .centerX, .equal, view, .centerX, 1, 0)
//      Constraint.make(textView, .centerY, .equal, view, .centerY, 1, 0)
//
//      Constraint.make("H:[v0(ivw)]", metrics: metrics, views: imageView)
//      Constraint.make(imageView, .centerX, .equal, view, .centerX, 1, 0)
//      Constraint.make(imageView, .centerY, .equal, view, .centerY, 0.5, 0)
//      Constraint.make(imageView, .width, .equal, imageView, .height, (600/405), 0)
//
//      Constraint.make("H:[v0(svw)]", metrics: metrics, views: stackView)
//      Constraint.make(stackView, .centerX, .equal, view, .centerX, 1, 0)
//      Constraint.make(stackView, .centerY, .equal, view, .centerY, 1.35, 0)
//      Constraint.make(stackView, .width, .equal, stackView, .height, (6/1), 0)
//
//      stackView.addArrangedSubviews(button1, button2)
//   }
//
//   func setupButtons() {
//      button1.addTarget(self, action: #selector(skip), for: [.touchUpInside, .touchUpOutside])
//      button2.addTarget(self, action: #selector(connectToiCloud), for: [.touchUpInside, .touchUpOutside])
//   }
//
//   func skip() {
//      shouldUseiCloud = false // store value
//      delegate?.moveToNextPage()
//   }
//
//   func connectToiCloud() {
//      shouldUseiCloud = true // store value
//      delegate?.moveToNextPage()
//   }
//}
