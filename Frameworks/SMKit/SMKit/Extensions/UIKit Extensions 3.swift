
import UIKit

/**
 NOTE: UIStackView, UILabel, UIImage
 */

// --------------------------- UIStackView --------------------------- //
// MARK: UIStackView extension

public extension UIStackView {
   
   public func addArrangedSubviews(_ views: UIView...) {
      for view in views {
         addArrangedSubview(view)
      }
   }
}

public extension UILabel {
   
   public convenience init(text: String? = nil, font: UIFont? = nil) {
      self.init(frame: .zero)
      self.text = text
      self.font = font
   }
}

public extension UIImage {
   
   public func draw(_ text: String, font: UIFont, color: UIColor, at point: CGPoint) -> UIImage? {
      
      let label = UILabel()
      label.text = text
      label.font = font
      label.textColor = color
      label.textAlignment = .center
      
      UIGraphicsBeginImageContextWithOptions(size, false, 0)
      draw(in: CGRect.init(origin: .zero, size: size))
      color.set()
      label.drawText(in: .init(center: point, size: size))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
   }
   
   public static func drawFront(_ image: UIImage?, text: String, at point: CGPoint) -> UIImage? {
      if let image = image {
         let font = UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 20)!
         UIGraphicsBeginImageContext(image.size)
         image.draw(in: .init(origin: .zero, size: image.size))
         UIColor.black.set()
         let string = NSMutableAttributedString.init(string: text)
         let range = NSRange.init(location: 0, length: string.length)
         string.addAttributes([NSFontAttributeName:font, NSForegroundColorAttributeName:UIColor.white], range: range)
         
         let rect = CGRect.make(point.x, point.y, image.size.width, image.size.height)
         string.draw(in: rect)
         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         
         return newImage
      } else {
         return nil
      }
      
   }
}




//
//+(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point
//{
//   UIFont *font = [UIFont fontWithName:@"Halter" size:21];
//   UIGraphicsBeginImageContext(image.size);
//   [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
//   CGRect rect = CGRectMake(point.x, (point.y - 5), image.size.width, image.size.height);
//   [[UIColor whiteColor] set];
//
//   NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:text];
//   NSRange range = NSMakeRange(0, [attString length]);
//
//   [attString addAttribute:NSFontAttributeName value:font range:range];
//   [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
//
//   NSShadow* shadow = [[NSShadow alloc] init];
//   shadow.shadowColor = [UIColor darkGrayColor];
//   shadow.shadowOffset = CGSizeMake(1.0f, 1.5f);
//   [attString addAttribute:NSShadowAttributeName value:shadow range:range];
//
//   [attString drawInRect:CGRectIntegral(rect)];
//   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//   UIGraphicsEndImageContext();
//
//   return newImage;
//}







