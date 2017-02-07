//
//  Cells.swift
//  OV
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/02/07.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit


class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
   var featuredAppsController: FeaturedAppsController?
   
   var appCategory: AppCategory? {
      didSet {
         
         if let name = appCategory?.name {
            nameLabel.text = name
         }
         
         appsCollectionView.reloadData()
      }
   }
   
   fileprivate let cellID = "appCellID"
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   let nameLabel: UILabel = {
      let l = UILabel()
      l.text = "Best New Apps"
      l.font = .systemFont(ofSize: 16)
      l.translatesAutoresizingMaskIntoConstraints = false
      return l
   }()
   
   let appsCollectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      
      collectionView.backgroundColor = .clear
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      
      return collectionView
   }()
   
   let dividerLineView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
   }()
   
   func setupViews() {
      backgroundColor = .clear
      
      contentView.addSubviews(appsCollectionView, dividerLineView, nameLabel)
      
      appsCollectionView.dataSource = self
      appsCollectionView.delegate = self
      
      appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellID)
      
      nameLabel.addAnchors(toTop: topAnchor, toRight: rightAnchor, toBottom: nil, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 30)
      
      dividerLineView.addAnchors(toTop: nil, toRight: rightAnchor, toBottom: bottomAnchor, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 0.5)
      
      appsCollectionView.addAnchors(toTop: nameLabel.bottomAnchor, toRight: rightAnchor, toBottom: dividerLineView.topAnchor, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 0, bottomConstant: 0, width: 0, height: 0)
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if let count = appCategory?.apps?.count {
         return count
      }
      return 0
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppCell
      cell.app = appCategory?.apps?[indexPath.item]
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: 100, height: frame.height - 32)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0, 14, 0, 14)
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if let app = appCategory?.apps?[indexPath.item] {
         featuredAppsController?.showAppDetailForApp(app)
      }
   }
}

class AppCell: UICollectionViewCell {
   
   var app: App? {
      didSet {
         if let name = app?.name {
            nameLabel.text = name
            
            let rect = NSString(string: name).boundingRect(with: .init(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            if rect.height > 20 {
               categoryLabel.frame = CGRect.init(x: 0, y: frame.width + 30, width: frame.width, height: 20)
               priceLabel.frame = .init(x: 0, y: frame.width + 56, width: frame.width, height: 20)
            } else {
               categoryLabel.frame = .init(x: 0, y: frame.width + 22, width: frame.width, height: 20)
               priceLabel.frame = .init(x: 0, y: frame.width + 40, width: frame.width, height: 20)
            }
            
            nameLabel.frame = .init(x: 0, y: frame.width + 5, width: frame.width, height: 40)
            nameLabel.sizeToFit()
         }
         
         categoryLabel.text = app?.category
         
         if let price = app?.price {
            priceLabel.text = "$\(price)"
         } else {
            priceLabel.text = ""
         }
         
         if let imageName = app?.imageName {
            imageView.image = UIImage.init(named: imageName)
         }
      }
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   let imageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFill
      iv.layer.cornerRadius = 16
      iv.layer.masksToBounds = true
      return iv
   }()
   
   let nameLabel: UILabel = {
      let label = UILabel()
      label.text = "Disney Build It: Frozen"
      label.font = .systemFont(ofSize: 14)
      label.numberOfLines = 2
      return label
   }()
   
   let categoryLabel: UILabel = {
      let label = UILabel()
      label.text = "Entertainment"
      label.font = .systemFont(ofSize: 13)
      label.textColor = .darkGray
      return label
   }()
   
   let priceLabel: UILabel = {
      let label = UILabel()
      label.text = "$3.99"
      label.font = .systemFont(ofSize: 13)
      label.textColor = .darkGray
      return label
   }()
   
   func setupViews() {
      contentView.addSubviews(imageView, nameLabel, categoryLabel, priceLabel)
      
      imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
      nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
      categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
      priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
   }
}











































































