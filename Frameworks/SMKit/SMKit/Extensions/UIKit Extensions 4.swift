
import UIKit

/**
 NOTE: UIButton, UIImage
 */


public extension UIButton {
   static public func systemButton(title: String? = nil, image: UIImage? = nil, titleColor: UIColor? = .white, font: UIFont? = UIFont.preferredFont(forTextStyle: .body), target: Any? = nil, selector: Selector? = nil) -> UIButton {
      
      let button = UIButton.init(type: .system)
      button.setTitle(title, for: .normal)
      button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
      button.imageView?.contentMode = .scaleAspectFit
      button.setTitleColor(titleColor, for: .normal)
      button.titleLabel?.font = font
      if let selector = selector {
         button.addTarget(target, action: selector, for: .touchUpInside)
      }
      return button
   }
}

public extension UIImage {
   public static func getWindowImage() -> UIImage? {
      if let keyWindow = UIApplication.shared.keyWindow {
         UIGraphicsBeginImageContextWithOptions(keyWindow.frame.size, keyWindow.isOpaque, 0)
         keyWindow.layer.render(in: UIGraphicsGetCurrentContext()!)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         return image
      }
      return nil
   }
}

