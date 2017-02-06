//
//  Cells.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/30.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

@objc enum CellEditingState: NSInteger {
   case middle, left, right, none
}

// MARK: -

@objc enum CellStyle: NSInteger {
   case unfolding, pullDown
}

// MARK: -

@objc protocol TransformableCellProtocol: class {
   var finishedHeight: CGFloat {get set}
}

class TransformableCell: DatasourceTableViewCell, TransformableCellProtocol
{
   var finishedHeight: CGFloat
   
   
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      finishedHeight = 44
      super.init(style: style, reuseIdentifier: reuseIdentifier)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   class func unfoldingCell() -> TransformableCell {
      return UnfoldingCell(style: .subtitle, reuseIdentifier: NSStringFromClass(UnfoldingCell.self))
   }
   
   class func pullDownCell() -> TransformableCell {
      return PullDownCell(style: .default, reuseIdentifier: NSStringFromClass(PullDownCell.self))
   }
   
   class func transformableCellWith(_ style: CellStyle) -> TransformableCell {
      switch style {
      case .pullDown:
         return TransformableCell.pullDownCell()
      case .unfolding:
         return TransformableCell.unfoldingCell()
      }
   }
}

// MARK: -

@objc protocol PullDownCellProtocol:class {
   var transformableView: UIView? {get set}
   
}

class PullDownCell: TransformableCell, PullDownCellProtocol
{
   var transformableView: UIView?
   
   override
   init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      var transform = CATransform3DIdentity
      transform.m34 = -1/500
      contentView.layer.sublayerTransform = transform
      
      transformableView = UIView(frame: contentView.bounds)
      transformableView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      transformableView?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
      
      contentView.addSubview(transformableView!)
      selectionStyle = .none
      
      //      textLabel?.autoresizingMask = UIViewAutoresizing.none
      textLabel?.translatesAutoresizingMaskIntoConstraints = false
      textLabel?.backgroundColor = .clear
      textLabel?.textColor = .white
      tintColor = .white
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override var textLabel: UILabel? {
      get {
         let label = super.textLabel
         if let label = label, label.superview != transformableView {
            transformableView?.addSubview(label)
         }
         return label
      }
   }
   
   override var detailTextLabel: UILabel? {
      get {
         let label = super.detailTextLabel
         if let label = label, label.superview != transformableView {
            transformableView?.addSubview(label)
         }
         return label
      }
   }
   
   override var imageView: UIImageView? {
      get {
         let iv = super.imageView
         if let iv = iv, iv.superview != transformableView {
            transformableView?.addSubview(iv)
         }
         return iv
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      
      logger.log(value: "layoutSubviews()")
      
      var fraction = frame.height / finishedHeight
      fraction = max(min(1, fraction), 0)
      
      let angle : CGFloat = CGFloat(M_PI_2) - asin(fraction)
      let transform = CATransform3DMakeRotation(angle, 1, 0, 0)
      transformableView?.frame = contentView.bounds
      transformableView?.layer.transform = transform
      transformableView?.backgroundColor = tintColor.colorWithBrightness(0.3 + 0.7*fraction)
      
      let contentViewSize = contentView.frame.size
      
      // OPT: Always accomodate 1 px to the top label to ensure two labels
      // won't display one px gap in between sometimes for certain angles
      transformableView?.frame = CGRect(x: 0, y: contentViewSize.height - finishedHeight,
                                        width: contentViewSize.width, height: finishedHeight)
      
      
      
      
      
      
      if let textLabel = self.textLabel, let text = textLabel.text {
         let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle.init()
         paragraphStyle.lineBreakMode = .byClipping
         
         let requiredLabelRect = NSString(string: text).boundingRect(with: contentViewSize,
                                                                     options: .usesLineFragmentOrigin,
                                                                     attributes: [NSFontAttributeName: textLabel.font,
                                                                                  NSParagraphStyleAttributeName: paragraphStyle],
                                                                     context: nil)
         let requiredLabelSize = requiredLabelRect.size
         
         if let imageView = imageView {
            imageView.frame = CGRect.init(x: 10 + requiredLabelSize.width + 10,
                                          y: (finishedHeight - imageView.frame.height) / 2,
                                          width: imageView.frame.width,
                                          height: imageView.frame.height)
            
            
         }
         
         textLabel.frame =  CGRect.init(x: 10,
                                        y: 0,
                                        width: contentViewSize.width - 20,
                                        height: finishedHeight)
         
      }
   }
}


// MARK: -

class UnfoldingCell: TransformableCell {
   
}
