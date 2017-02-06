import UIKit

class PageViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .clear
   }
}

class PageCell: BaseCell {
   
   var contentViewController: UIViewController? {
      didSet {
         loadViews()
      }
   }
   
   fileprivate func loadViews() {
      
      guard let vc = contentViewController else {return}
      
      for v in contentView.subviews {
         v.removeFromSuperview()
      }
      
      contentView.addSubview(vc.view)
      
      Constraint.extend(vc.view)
   }
}


class BaseCell: UICollectionViewCell {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented") // from storyboard
   }
   
   func setupViews() {
      contentView.clipsToBounds = true
   }
}
