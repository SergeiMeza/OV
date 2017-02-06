//
//  NSKit Extensions.swift
//  delete1
//
//  Created by Jeany Meza Rodriguez on 2016/09/20.
//  Copyright © 2016 MezApps. All rights reserved.
//

import UIKit

/**
 NOTE: NSAttributedString, NSMutableAttributedString and NSLayoutConstraint extensions
 */

public typealias Constraint = NSLayoutConstraint
public typealias AttributedString = NSAttributedString
public typealias MutableAttributedString = NSMutableAttributedString

// --------------------------- NSAttributedString --------------------------- //
// MARK: NSAttributedString extension
// DESCRIPTION: shortcut to write attributed strings

public extension NSAttributedString {
   // do it smarter
   static public func make(_ s: String, _ size: CGFloat? = 14 ,_ weight: CGFloat) -> NSAttributedString {
      return NSAttributedString(string: s, attributes: [
         NSForegroundColorAttributeName: UIColor.black,
         NSFontAttributeName: UIFont.systemFont(ofSize: size!, weight: weight)
         ])
   }
}

// --------------------------- NSMutableAttributedString --------------------------- //
// MARK: NSMutableAttributedString extension
// DESCRIPTION: shortcut to modify attributed strings

public extension NSMutableAttributedString {
   
   public enum Size {
      case title, subtitle, header, body
   }
   
   public enum Weight {
      case light, regular, bold, medium
   }
   
   public func append(_ string: String, size: CGFloat, weight: CGFloat) {
      append(NSAttributedString.make(string, size, weight))
      alignAt(.center)
   }
   
   private func append(_ string: String, size: Size, weight: CGFloat) {
      switch size {
      case .body: append(string, size: 14, weight: weight)
      case .header: append(string, size: 18, weight: weight)
      case .subtitle: append(string, size: 20, weight: weight)
      case .title: append(string, size: 24, weight: weight)
      }
   }
   
   public func append(_ string: String, size: Size, weight: Weight) {
      switch weight {
      case .light: append(string, size: size, weight: UIFontWeightLight)
      case .regular: append(string, size: size, weight: UIFontWeightRegular)
      case .bold: append(string, size: size, weight: UIFontWeightBold)
      case .medium: append(string, size: size, weight: UIFontWeightMedium)
      }
   }
   
   public func appendLight(_ string: String, size: Size) {
      append(string, size: size, weight: .light)
   }
   
   public func appendBold(_ string: String, size: Size) {
      append(string, size: size, weight: .bold)
   }
   
   public func append(_ string: String) {
      append(string, size: .body, weight: .light)
   }
   
   
   public func add(lines: Int) {
      guard lines > 0 else { return }
      for _ in 1...lines {
         append(NSAttributedString(string: "\n"))
      }
   }
   
   public func alignAt(_ alignment: NSTextAlignment) {
      
      let paraghraphStyle = NSMutableParagraphStyle()
      paraghraphStyle.alignment = alignment
      
      let length = self.string.characters.count
      
      self.addAttributes([NSParagraphStyleAttributeName: paraghraphStyle], range: NSRange(location: 0, length: length))
   }
}

extension NSMutableAttributedString {
   
   public func appendNewLine() {
      append(NSAttributedString(string: "\n"))
   }
   
   public func centerAlignWithSpacing(_ lineSpacing: CGFloat) {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      paragraphStyle.lineSpacing = lineSpacing
      setParagraphStyle(paragraphStyle)
   }
   
   public func setLineSpacing(_ lineSpacing: CGFloat) {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = lineSpacing
      setParagraphStyle(paragraphStyle)
   }
   
   func setParagraphStyle(_ style: NSParagraphStyle) {
      let range = NSMakeRange(0, string.characters.count)
      addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
   }
}

// --------------------------- NSLayoutConstraint --------------------------- //
// MARK: NSLayoutConstraint extension
// DESCRIPTION: makeWithFormat and constraintsWithFormat class methods

public extension NSLayoutConstraint {
   
   static public func fillSuperview(with view: UIView) {
      make("H:|[v0]|", views: view)
      make("V:|[v0]|", views: view)
   }
   
   static public func center(_ i: UIView) {
      NSLayoutConstraint(item: i, attribute: .centerX, relatedBy: .equal, toItem: i.superview!, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
      NSLayoutConstraint(item: i, attribute: .centerY, relatedBy: .equal, toItem: i.superview!, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
      i.translatesAutoresizingMaskIntoConstraints = false
   }
   
   static public func center(_ i: UIView, mX: CGFloat, mY: CGFloat, cX: CGFloat, cY: CGFloat) {
      NSLayoutConstraint(item: i, attribute: .centerX, relatedBy: .equal, toItem: i.superview!, attribute: .centerX, multiplier: mX, constant: cX).isActive = true
      NSLayoutConstraint(item: i, attribute: .centerY, relatedBy: .equal, toItem: i.superview!, attribute: .centerY, multiplier: mY, constant: cY).isActive = true
      i.translatesAutoresizingMaskIntoConstraints = false
   }
   
   static public func make(_ i: UIView, _ a: NSLayoutAttribute, _ rb: NSLayoutRelation, _ c: CGFloat) {
      make(i, a, nil, .notAnAttribute, 1, c)
   }
   
   static public func make(_ i: UIView, _ a1: NSLayoutAttribute, superView a2: NSLayoutAttribute, _ m: CGFloat, _ c: CGFloat) {
      make(i, a1, i.superview, a2, m, c)
   }
   
   static public func make(_ i: UIView, _ a1: NSLayoutAttribute, _ toI: UIView?, _ a2: NSLayoutAttribute, _ m: CGFloat, _ c: CGFloat) {
      let c = NSLayoutConstraint(item: i, attribute: a1, relatedBy: .equal, toItem: toI, attribute: a2, multiplier: m, constant: c)
      i.translatesAutoresizingMaskIntoConstraints = false
      c.isActive = true
   }
   
   static fileprivate func constraints(_ format: String, options: NSLayoutFormatOptions?, metrics: [String:Any]?, views: [UIView]) -> [Constraint] {
      var viewsDictionary = [String: UIView]()
      for (i, view) in views.enumerated() {
         let key = "v\(i)"
         viewsDictionary[key] = view
         view.translatesAutoresizingMaskIntoConstraints = false
      }
      let options : NSLayoutFormatOptions = options ?? NSLayoutFormatOptions()
      let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: viewsDictionary)
      for c in constraints {
         c.isActive = true
      }
      return constraints
   }
   
   static public func constraints(_ format: String, views: UIView...) -> [Constraint] {
      return constraints(format, options: nil, metrics: nil, views: views)
   }
   
   static public func constraints(_ format: String, metrics: [String:Any]?, views: UIView...) -> [Constraint] {
      return constraints(format, options: nil, metrics: metrics, views: views)
   }
   
   static public func constraints(_ format: String, options: NSLayoutFormatOptions?, metrics: [String:Any]?, views: UIView...) -> [Constraint] {
      return constraints(format, options: options, metrics: metrics, views: views)
   }
   
   static public func make(_ format: String, views: UIView...) {
      make(format, options: nil, metrics: nil, views: views)
   }
   
   static public func make(_ format: String, metrics: [String: Any]?, views: UIView...) {
      make(format, options: nil, metrics: metrics, views: views)
   }
   
   static public func make(_ format: String, options: NSLayoutFormatOptions?, metrics: [String: Any]?, views: UIView...) {
      make(format, options: options, metrics: metrics, views: views)
   }
   
   static fileprivate func make(_ format: String, options: NSLayoutFormatOptions?,  metrics: [String: Any]?, views: [UIView]) {
      let _ = constraints(format, options: options, metrics: metrics, views: views)
   }
}
