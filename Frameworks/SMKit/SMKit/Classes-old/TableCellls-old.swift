
import UIKit

/// created on 16/10/25
open class SMCustomTableViewCell03: SMBaseTableViewCell {
   
   open let titleLabel: UILabel = {
      let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
      l.text = "Hello World"
      l.textColor = UIColor.init(white: 1, alpha: 0.6)
      l.textAlignment = .left
      return l
   }()
   
   open let imageview: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      return iv
   }()

   override open func setupViews() {
      super.setupViews()
      
      contentView.addSubviews(titleLabel, imageview)
      
      Constraint.make("H:|-[v0]-|", views: titleLabel)
      Constraint.make("V:|[v0]|", views: titleLabel)
      
      Constraint.make("H:[v0]-|", views: imageview)
      Constraint.make(imageview, .width, imageview, .height, 1, 0)
      Constraint.make(imageview, .height, imageview.superview, .height, 0.5, 0)
      Constraint.make(imageview, .centerY, superView: .centerY, 1, 0)
      
   }
}

/// Description: H:Image-(Text1)|Text2-Image ; H: dim-0-0 ; V: Text1-Text2
open class SMCustomTableViewCell02: SMBaseTableViewCell {
   
   private let stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.alignment = .center
      sv.distribution = .fill
      sv.spacing = 8
      return sv
   }()
   
   open let leftImageView: UIImageView = {
      let iv = UIImageView()
      iv.layer.cornerRadius = 12
      iv.layer.masksToBounds = true
      iv.contentMode = .scaleAspectFit
      return iv
   }()
   
   open let rightImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      return iv
   }()
   
   open let labelStackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .vertical
      sv.alignment = .leading
      sv.distribution = .fill
      sv.spacing = 4
      return sv
   }()
   
   open let titleLabel: UILabel = {
      let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
      l.text = "Hello World"
      l.textColor = .black
      return l
   }()
   
   open let subtitleLabel: UILabel = {
      let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightUltraLight)
      l.text = "Hello World"
      l.textColor = .black
      return l
   }()
   
   open let dimView : UIView = {
      let v = UIView()
      v.bg = .red
      return v
   }()
   
   override open func setupViews() {
      super.setupViews()
      
      contentView.addSubviews(dimView, stackview)
      stackview.addArrangedSubviews(leftImageView, labelStackview, rightImageView)
      labelStackview.addArrangedSubviews(titleLabel, subtitleLabel)
   }
   
   open override func setupConstraints() {
      super.setupConstraints()
      
      Constraint.make("H:|-[v0]-|", views: stackview)
      Constraint.make(stackview, .centerY, superView: .centerY, 1, 0)
      
      Constraint.make("H:|[v0]", views: dimView)
      Constraint.make("V:|[v0]|", views: dimView)
      Constraint.make(dimView, .height, dimView, .width, 1, 0)
      
      Constraint.make(leftImageView, .width, leftImageView, .height, 1, 0)
      Constraint.make(leftImageView, .height, nil, .notAnAttribute, 1, 50)
      
      Constraint.make(rightImageView, .width, rightImageView, .height, 1, 0)
   }
}

/// Description: H:Image-Text-Image and H: dim-0-0
open class SMCustomTableViewCell01: SMBaseTableViewCell {
   
   private let stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.alignment = .center
      sv.distribution = .fill
      sv.spacing = 8
      sv.bg = .white
      return sv
   }()
   
   open let leftImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      return iv
   }()
   
   open let rightImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      return iv
   }()
   
   open let titleLabel: UILabel = {
      let l = UILabel()
      l.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
      l.text = "Hello World"
      l.textColor = UIColor.init(white: 1, alpha: 0.6)
      l.textAlignment = .left
      return l
   }()
   
   open let dimView : UIView = {
      let v = UIView()
      v.bg = .red
      return v
   }()

   override open func setupViews() {
      super.setupViews()
      
      contentView.addSubviews(dimView, stackview)
      stackview.addArrangedSubviews(leftImageView, titleLabel, rightImageView)
      
      
   }
   
   open override func setupConstraints() {
      super.setupConstraints()
      
      Constraint.make("H:|[v0]-|", views: stackview)
      Constraint.make("V:|[v0]|", views: stackview)
      
      Constraint.make("H:|[v0]", views: dimView)
      Constraint.make("V:|[v0]|", views: dimView)
      Constraint.make(dimView, .height, dimView, .width, 1, 0)
      
      Constraint.make("V:|[v0]|", views: leftImageView)
      Constraint.make(leftImageView, .width, leftImageView, .height, 1, 0)
      Constraint.make(leftImageView, .height, stackview, .height, 1, 0)
      
      Constraint.make(rightImageView, .width, rightImageView, .height, 1, 0)
   }
}

/// created on 16/10/25
open class SMBaseTableViewCell: UITableViewCell {
   
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
      setupConstraints()
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   open func setupViews() { }
   
   open func setupConstraints() { }
   
   open func prepareView() { }
}
