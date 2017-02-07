
import SMKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
   fileprivate let cellID = "cellID"
   fileprivate let largeCellID = "largeCellID"
   fileprivate let headerID = "headerID"
   
   var featuredApps: FeaturedApps?
   var appCategories: [AppCategory]?
   
   override func viewDidLoad() {
      super.viewDidLoad()
   
      title = "Feature Apps"
      
      AppCategory.fetchFeatureApps { (featuredApps) in
         self.featuredApps = featuredApps
         self.appCategories = featuredApps.appCategories
         self.collectionView?.reloadData()
      }
      
      collectionView?.backgroundColor = .white
      
      collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellID)
      collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellID)
      
      collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
   }
   
   func showAppDetailForApp(_ app: App) {
      let layout = UICollectionViewFlowLayout()
      
      let appDetailController = AppDetailController(collectionViewLayout: layout)
      appDetailController.app = app
      navigationController?.pushViewController(appDetailController, animated: true)
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell: CategoryCell
      
      if indexPath.item == 2 {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellID, for: indexPath) as! LargeCategoryCell
      } else {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CategoryCell
      }
      
      cell.appCategory = appCategories?[indexPath.item]
      cell.featuredAppsController = self
      
      return cell
   }
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if let count = appCategories?.count {
         return count
      }
      return 0
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      if indexPath.item == 2 {
         return .init(width: view.frame.width, height: 160)
      }
      
      return .init(width: view.frame.width, height: 230)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return .init(width: view.frame.width, height: 120)
   }
   
   override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! Header
      
      header.appCategory = featuredApps?.bannerCategory
      
      return header
   }
}


class Header: CategoryCell {
   
   let cellID = "bannerCellID"
   
   override func setupViews() {
      appsCollectionView.dataSource = self
      appsCollectionView.delegate = self
      
      appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: cellID)
      
      contentView.addSubview(appsCollectionView)
      
      appsCollectionView.addAnchors(toTop: topAnchor, toRight: rightAnchor, toBottom: bottomAnchor, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 0, bottomConstant: 0, width: 0, height: 0)
   }
   
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return .zero
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppCell
      cell.app = appCategory?.apps?[indexPath.item]
      return cell
   }
   
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: frame.width / 2 + 50, height: frame.height)
   }
   
   fileprivate class BannerCell: AppCell {
      fileprivate override func setupViews() {
         imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cg
         imageView.layer.borderWidth = 0.5
         imageView.layer.cornerRadius = 0
         imageView.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(imageView)
         
         imageView.addAnchors(toTop: contentView.topAnchor, toRight: contentView.rightAnchor, toBottom: contentView.bottomAnchor, toLeft: contentView.leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 0, bottomConstant: 0, width: 0, height: 0)
      }
   }
}

class LargeCategoryCell: CategoryCell {
   
   fileprivate let largeAppCellID = "largeAppCellID"
   
   override func setupViews() {
      super.setupViews()
      appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCellID)
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellID, for: indexPath) as! AppCell
      cell.app = appCategory?.apps?[indexPath.item]
      return cell
   }
   
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: 200, height: frame.height - 32)
   }
   
   fileprivate class LargeAppCell: AppCell {
      fileprivate override func setupViews() {
         imageView.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(imageView)
         
         imageView.addAnchors(toTop: contentView.topAnchor, toRight: contentView.rightAnchor, toBottom: contentView.bottomAnchor, toLeft: contentView.leftAnchor, topConstant: 2, rightConstant: 0, leftConstant: 0, bottomConstant: 14, width: 0, height: 0)
      }
   }
}
























































