
import UIKit

open class SMButton01: UIButton {
   
   open func setProperties(image: UIImage, title: String, titleSize: CGFloat, color: UIColor, titleColor: UIColor, shadowColor: UIColor) {
      
      let shadowImage = image
      
      let label = UILabel()
      label.text = title
      label.textColor = titleColor
      label.textAlignment = .center
      label.font = UIFont.init(name: "HelveticaNeue-CondensedBlack", size: titleSize)
      
      UIGraphicsBeginImageContextWithOptions(image.size + CGSize.make(15,15), false, 0)
      shadowColor.setFill()
      shadowImage.draw(in: .init(origin: .make(15,15), size: image.size))
      color.setFill()
      image.draw(in: .init(origin: .zero, size: image.size))
      label.drawText(in: .init(origin: .zero, size: image.size))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      setImage(newImage, for: .normal)
      
      UIGraphicsBeginImageContextWithOptions(image.size + CGSize.make(15,15), false, 0)
      shadowColor.setFill()
      shadowImage.draw(in: .init(origin: .make(15,15), size: image.size))
      color.setFill()
      image.draw(in: .init(origin: .make(10,10), size: image.size))
      label.drawText(in: .init(origin: .make(10,10), size: image.size))
      let newImage2 = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      setImage(newImage2, for: .highlighted)
   }
   
   open func setProperties(image: UIImage, buttonImage: UIImage, color: UIColor, buttonColor: UIColor, shadowColor: UIColor) {
      
      let shadowImage = buttonImage
      
      UIGraphicsBeginImageContextWithOptions(buttonImage.size + CGSize.make(4,4), false, 0)
      shadowColor.setFill()
      shadowImage.draw(in: .init(origin: .make(4,4), size: buttonImage.size))
      buttonColor.setFill()
      buttonImage.draw(in: .init(origin: .zero, size: buttonImage.size))
      color.setFill()
      image.draw(in: .init(center: buttonImage.center, size: image.size))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      setImage(newImage, for: .normal)
      
      UIGraphicsBeginImageContextWithOptions(buttonImage.size + CGSize.make(4,4), false, 0)
      shadowColor.setFill()
      shadowImage.draw(in: .init(origin: .make(4,4), size: buttonImage.size))
      buttonColor.setFill()
      buttonImage.draw(in: .init(origin: .make(3,3), size: buttonImage.size))
      color.setFill()
      image.draw(in: .init(center: buttonImage.center + CGPoint.make(3,3), size: image.size))
      let newImage2 = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      setImage(newImage2, for: .highlighted)
   }
   
   open func setProperties(image: UIImage, color: UIColor) {
      UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
      color.setFill()
      image.draw(in: .init(origin: .zero, size: image.size))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      setImage(newImage, for: .normal)
   }
}

