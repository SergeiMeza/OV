//
//  AppDetailController.swift
//  OV
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/02/07.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
   var app: App? {
      didSet {
         
         if app?.screenshots != nil {
            return
         }
         
         if let id = app?.id {
            let urlString = "http://www.statsallday.com/appstore/appdetail?id=\(id)"
            
            URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) in
               
               if error != nil {
                  print(error!)
                  return
               }
               
               do {
                  
                  let json  = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                  
                  let appDetail = App()
                  appDetail.setValuesForKeys(json as! [String: AnyObject])
                  
                  self.app = appDetail
                  
                  DispatchQueue.main.async(execute: { 
                     self.collectionView?.reloadData()
                  })
               } catch let err {
                  print(err)
               }
            }).resume()
         }
      }
   }
   
   fileprivate let headerID = "headerID"
   fileprivate let cellID = "cellID"
   fileprivate let descriptionCellID = "descriptionCellID"
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      collectionView?.alwaysBounceVertical = true
      
      collectionView?.backgroundColor = .white
      
      collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
      
      collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: cellID)
      collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellID)
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      if indexPath.item == 1 {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellID, for: indexPath) as! AppDetailDescriptionCell
         
         cell.textView.attributedText = descriptionAttributedText()
         
         return cell
      }
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScreenshotsCell
      
      cell.app = app
      
      return cell
   }
   
   fileprivate func descriptionAttributedText() -> NSAttributedString {
      let attributedText = NSMutableAttributedString.init(string: "Description\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
      
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 10
      
      let range = NSMakeRange(0, attributedText.string.characters.count)
      attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
      
      if let description = app?.desc {
         attributedText.append(NSAttributedString(string: description, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName: UIColor.darkGray]))
      }
      
      return attributedText
   }
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      if indexPath.item == 1 {
         
         let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
         let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
         let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
         
         return .init(width: view.frame.width, height: rect.height + 30)
      }
      
      return .init(width: view.frame.width, height: 170)
   }
   
   override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! AppDetailHeader
      header.app = app
      return header
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return .init(width: view.frame.width, height: 170)
   }
}

class AppDetailDescriptionCell: BaseCell {
   
   let textView: UITextView = {
      let tv = UITextView()
      tv.text = "SAMPLE DESCRIPTION"
      return tv
   }()
   
   let dividerLineView: UIView = {
      let v = UIView()
      v.bg = UIColor.init(white: 0.4, alpha: 0.4)
      return v
   }()
   
   override func setupViews() {
      super.setupViews()
      
      contentView.addSubviews(textView, dividerLineView)
      
      textView.addAnchors(toTop: contentView.topAnchor, toRight: contentView.rightAnchor, toBottom: dividerLineView.topAnchor, toLeft: contentView.leftAnchor, topConstant: 4, rightConstant: 8, leftConstant: 8, bottomConstant: 4, width: 0, height: 0)
      
      dividerLineView.addAnchors(toTop: nil, toRight: contentView.rightAnchor, toBottom: contentView.bottomAnchor, toLeft: contentView.leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 1)
   }
}

class AppDetailHeader:  BaseCell {
   
   var app: App? {
      didSet {
         if let imageName = app?.imageName {
            imageView.image = UIImage(named: imageName)
         }
         
         nameLabel.text = app?.name
         
         if let price = app?.price?.stringValue {
            buyButton.setTitle("$\(price)", for: .normal)
         }
      }
   }
   
   
   let imageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      iv.layer.cornerRadius = 16
      iv.layer.masksToBounds = true
      return iv
   }()
   
   let segmentedControl: UISegmentedControl = {
      let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
      sc.tintColor = .darkGray
      sc.selectedSegmentIndex = 0
      return sc
   }()
   
   let nameLabel: UILabel = {
      let l = UILabel()
      l.text = "Test"
      l.font = .systemFont(ofSize: 16)
      return l
   }()
   
   let buyButton: UIButton = {
      let b = UIButton(type: .system)
      b.setTitle("BUY", for: .init())
//      b.setTitle("BUY", for: .normal)  // there is a difference between .init() and .normal (.normal doesnt highlight when tapped)
      b.layer.borderColor = UIColor.rgb(red: 0, green: 129, blue: 250).cg
      b.layer.borderWidth = 1
      b.layer.cornerRadius = 5
      b.titleLabel?.font = .boldSystemFont(ofSize: 14)
      return b
   }()
   
   let dividerLineView: UIView = {
      let v = UIView()
      v.bg = UIColor.init(white: 0.4, alpha: 0.4)
      return v
   }()
   
   override func setupViews() {
      super.setupViews()
      
      contentView.addSubviews(imageView, segmentedControl, nameLabel, buyButton, dividerLineView)
      
      imageView.addAnchors(toTop: contentView.topAnchor, toRight: nil, toBottom: nil, toLeft: contentView.leftAnchor, topConstant: 14, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 100, height: 100)
      
      nameLabel.addAnchors(toTop: contentView.topAnchor, toRight: contentView.rightAnchor, toBottom: nil, toLeft: imageView.rightAnchor, topConstant: 14, rightConstant: 0, leftConstant: 8, bottomConstant: 0, width: 0, height: 20)
      
      segmentedControl.addAnchors(toTop: nil, toRight: contentView.rightAnchor, toBottom: contentView.bottomAnchor, toLeft: contentView.leftAnchor, topConstant: 0, rightConstant: 40, leftConstant: 40, bottomConstant: 8, width: 60, height: 35)
      
      buyButton.addAnchors(toTop: nil, toRight: rightAnchor, toBottom: bottomAnchor, toLeft: nil, topConstant: 0, rightConstant: 14, leftConstant: 0, bottomConstant: 56, width: 60, height: 32)
   
      dividerLineView.addAnchors(toTop: nil, toRight: contentView.rightAnchor, toBottom: contentView.bottomAnchor, toLeft: contentView.leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 0, bottomConstant: 0, width: 0, height: 1)
   }
   
}

class BaseCell: UICollectionViewCell {
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setupViews() {
      
   }
}















































