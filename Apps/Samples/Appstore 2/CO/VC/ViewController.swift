
/**
   App Store app
 
      NavController
         NavBar
            CollectionView
               Header
                  CollectionView
                     looping Cells
               Cells
                  CollectionView
                     Cells
               Footer
                     Header
                        Label
                     Cells
                        Button
                     Footer
                        StackView
                           Button
         NavFooter
 
 */


import SMKit

class FeaturedAppsDatasource: CollectionViewDatasource {
   
   override init() {
      super.init()
      
      objects = ["1", "2", "3"]
   }
   
   override func cellClasses() -> [DatasourceCollectionViewCell.Type] {
      return [BaseCell.self]
   }
   
   override func headerClasses() -> [DatasourceCollectionViewCell.Type]? {
      return [Header.self]
   }
   
   override func footerClasses() -> [DatasourceCollectionViewCell.Type]? {
      return [Footer.self]
   }
   
   override func headerItem(_ section: Int) -> Any? {
      return "header"
   }
   
   override func footerItem(_ section: Int) -> Any? {
      return "footer"
   }
   
   override func numberOfSections() -> Int {
      return 1
   }
}

// MARK: -

class Header: BaseCell {
   
   override func setupViews() {
      
//      contentView.addSubviews()
      
      
      contentView.bg = .orange
   }
}

// MARK: -

class Footer: BaseCell {
   
   fileprivate let footerCollectionViewController = FooterCollectionViewController()
   
   override func setupViews() {

      let collectionView = footerCollectionViewController.view!

      contentView.addSubviews(collectionView)

      collectionView.fillSuperview()
      
      contentView.bg = .green
   }
   
   fileprivate class FooterDatasource: CollectionViewDatasource {
      
      override init() {
         super.init()
         
         objects = ["1", "2", "3"]
      }
      
      override func headerClasses() -> [DatasourceCollectionViewCell.Type]? {
         return [FooterHeader.self]
      }
      
      override func cellClasses() -> [DatasourceCollectionViewCell.Type] {
         return [FooterCell.self]
      }
      
      fileprivate override func footerClasses() -> [DatasourceCollectionViewCell.Type]? {
         return [FooterFooter.self]
      }
      
      override func numberOfSections() -> Int {
         return 1
      }
   }
   
   fileprivate class FooterCollectionViewController: DatasourceCollectionViewController {
      
      override init() {
         super.init()
         
         datasource = FooterDatasource()
      }
      
      required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }
      
      fileprivate override func viewDidLoad() {
         super.viewDidLoad()
         
         layout?.minimumLineSpacing = 0
         
         collectionView?.bg = .yellow
      }
      
      fileprivate override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return .init(width: view.frame.width, height: 44)
      }
      
      fileprivate func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         return .init(width: view.frame.width, height: 44)
      }
      
      fileprivate func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
         return .init(width: view.frame.width, height: 150)
      }
      
   }
}

// MARK: -

class FooterHeader: DatasourceCollectionViewCell {
   
   let infoLabel: UILabel = {
      let label = UILabel()
      label.text = "Quik Links"
      label.font = UIFont.preferredFont(forTextStyle: .title3)
      return label
   }()
   
   override func setupViews() {
      super.setupViews()
      
      separatorLineView.isHidden = false
      separatorLineView.bg = UIColor.init(white: 0.5, alpha: 0.5)
      
      contentView.addSubviews(infoLabel)
      
      infoLabel.addAnchors(toTop: topAnchor, toRight: rightAnchor, toBottom: bottomAnchor, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 0)
      
      
      contentView.bg = .white
   }
}

// MARK: -

class FooterCell: DatasourceCollectionViewCell {
   
   let cellButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("About Personalization", for: .init())
      button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
      return button
   }()
   
   override func setupViews() {
      super.setupViews()
      
      separatorLineView.isHidden = false
      separatorLineView.bg = UIColor.init(white: 0.5, alpha: 0.5)
      
      contentView.addSubviews(cellButton)
      
      cellButton.anchorCenterToSuperView()
      
      contentView.bg = .blue
   }
}

// MARK: -

class FooterFooter: DatasourceCollectionViewCell {
   
   
   override func setupViews() {
      super.setupViews()
      
      
      contentView.bg = .cyan
   }
}

// MARK: -

class BaseCell: DatasourceCollectionViewCell {
   
   override func setupViews() {
      
      separatorLineView.isHidden = false
      separatorLineView.bg = UIColor.init(white: 0.4, alpha: 0.4)
      
      contentView.addSubviews(separatorLineView)
      
      separatorLineView.addAnchors(toTop: nil, toRight: rightAnchor, toBottom: bottomAnchor, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 1)
      
      
      contentView.backgroundColor = .red
   }
}

// MARK: -

class BaseHorizontalCollectionViewController: DatasourceCollectionViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      layout?.scrollDirection = .horizontal
      collectionView?.alwaysBounceVertical = false
   }
}

// MARK: -

class FeaturedAppsController: DatasourceCollectionViewController {
   
   override init() {
      super.init()
      
      datasource = FeaturedAppsDatasource()
      
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "Featured"
      navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: nil, action: nil)
      
      layout?.minimumLineSpacing = 0
      collectionView?.bg = .yellow
   }
   
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: view.frame.width, height: 200)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return .init(width: view.frame.width, height: 150)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
      return .init(width: view.frame.width, height: 400)
   }
}








/**
 
import SMKit

// MARK: -

class FeaturedAppsDatasource: CollectionViewDatasource {
   
   var featuredApps: FeaturedApps? // use it for header
   var appCategories: [AppCategory]? // use it for cells
   
   override init() {
      super.init()
      objects = appCategories
   }
   
   override func headerClasses() -> [DatasourceCollectionViewCell.Type]? {
      return []
   }
   
   override func cellClasses() -> [DatasourceCollectionViewCell.Type] {
      return [CategoryCell.self]
   }
}

// MARK: -

class FeaturedAppsController: DatasourceCollectionViewController { // FeatureAppsCategory + // appCategories
   
   override init() {
      super.init()
      
      datasource = FeaturedAppsDatasource()
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "Featured"
      
      collectionView?.bg = .yellow
      
      layout?.minimumLineSpacing = 0
   }
   
   
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: view.frame.width, height: 200)
   }
   
}

// MARK: -

class CategoryCell: DatasourceCollectionViewCell {
   
   override var datasourceItem: Any? {
      didSet {
//         let appsDatasource = datasourceItem as? AppsDatasource
//         appsCollectionViewController.datasource = appsDatasource
      }
   }
   
   let appsCollectionViewController = AppsCollectionViewController()
   
   let nameLabel: UILabel = {
      let label = UILabel()
      label.text = "New Apps We Love"
      label.font = UIFont.preferredFont(forTextStyle: .title2)
      return label
   }()
   
   let showAllItemsButton: UIButton = {
      let button = UIButton.init(type: .system)
      button.setTitle("See All>", for: .init())
      button.setTitleColor(.gray, for: .init())
      button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
      return button
   }()
   
   override func setupViews() {
      super.setupViews()
      
      let collectionView = appsCollectionViewController.view!
      
      contentView.addSubviews(nameLabel, showAllItemsButton, collectionView)
      
      nameLabel.addAnchors(toTop: topAnchor, toRight: rightAnchor, toBottom: nil, toLeft: leftAnchor, topConstant: 8, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 30)
      
      showAllItemsButton.addAnchors(toTop: nil, toRight: rightAnchor, toBottom: nameLabel.bottomAnchor, toLeft: nil, topConstant: 0, rightConstant: 14, leftConstant: 0, bottomConstant: 0, width: 0, height: 0)
      
      collectionView.addAnchors(toTop: nameLabel.bottomAnchor, toRight: rightAnchor, toBottom: bottomAnchor, toLeft: leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 0, bottomConstant: 0, width: 0, height: 0)
      
      separatorLineView.isHidden = false
      
      contentView.bg = .orange
   }
}

class Header: CategoryCell {
   
   override func setupViews() {
      
      
   }
   
   fileprivate class BannerCollectionViewController: D
}

// MARK: -

class CategoryDatasource: CollectionViewDatasource {
 
   var appCategory: AppCategory?
   
   
}

// MARK: -


class AppsCollectionViewController: DatasourceCollectionViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      layout?.scrollDirection = .horizontal
      layout?.minimumLineSpacing = 10
      collectionView?.alwaysBounceVertical = false
      collectionView?.bg = .cyan
   }
   
   override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: 140, height: view.frame.height - 32)
   }
}

// MARK: -


class AppCell: DatasourceCollectionViewCell {
   
   override var datasourceItem: Any? {
      didSet {
         
      }
   }
   
   let imageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFill
      iv.layer.cornerRadius = 16
      iv.layer.masksToBounds = true
      iv.bg = .green
      return iv
   }()
   
   let nameLabel: UILabel = {
      let label = UILabel()
      label.text = "Disney Build It: Frozen"
      label.font = UIFont.preferredFont(forTextStyle: .body)
      label.numberOfLines = 2
      return label
   }()
   
   let categoryLabel: UILabel = {
      let label = UILabel()
      label.text = "Entertainment"
      label.font = UIFont.preferredFont(forTextStyle: .caption1)
      label.textColor = .darkGray
      return label
   }()
   
   let priceLabel: UILabel = {
      let label = UILabel()
      label.text = "$3.99"
      label.font = UIFont.preferredFont(forTextStyle: .caption2)
      label.textColor = .darkGray
      return label
   }()
   
   
   override func setupViews() {
      super.setupViews()
      
      contentView.addSubviews(imageView, nameLabel, categoryLabel, priceLabel)
      
      imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
      nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
      categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
      priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
      
      contentView.bg = .red
   }
}

// MARK: -

class FeaturedApps: NSObject {
   
   var bannerCategory: AppCategory?
   var appCategories: [AppCategory]?
   
   override func setValue(_ value: Any?, forKey key: String) {
      if key == "categories" {
         appCategories = [AppCategory]()
         
         for dict in value as! [[String: AnyObject]] {
            let appCategory = AppCategory()
            appCategory.setValuesForKeys(dict)
            appCategories?.append(appCategory)
         }
      } else if key == "bannerCategory" {
         bannerCategory = AppCategory()
         bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
      } else {
         super.setValue(value, forKey: key)
      }
   }
}




// MARK: -

class AppCategory: NSObject {
   
   var name: String?
   var apps: [App]?
   var type: String?
   
   override func setValue(_ value: Any?, forKey key: String) {
      
      if key == "apps" {
         apps = [App]()
         for dict in value as! [[String: AnyObject]] {
            let app = App()
            app.setValuesForKeys(dict)
            apps?.append(app)
         }
      } else {
         super.setValue(value, forKey: key)
      }
   }
   
   static func fetchFeatureApps(_ completion: @escaping (FeaturedApps) -> ()) {
      
      let urlString = "http://www.statsallday.com/appstore/featured"
      
      URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
         if error != nil {
            print(error!)
            return
         }
         
         do {
            let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
            
            let featuredApps = FeaturedApps()
            featuredApps.setValuesForKeys(json as! [String:AnyObject])
            
            DispatchQueue.main.async {
               completion(featuredApps)
            }
         } catch let error {
            print(error)
         }
         }.resume()
   }
   
   static func sampleAppCategories() -> [AppCategory] {
      
      let bestNewAppsCategory = AppCategory()
      bestNewAppsCategory.name = "Best New Apps"
      
      var apps = [App]()
      
      // logic
      let frozenApp = App()
      frozenApp.name = "Disney Build It: Frozen"
      frozenApp.imageName = "Frozen"
      frozenApp.category = "Entertainment"
      frozenApp.price = NSNumber(value: 3.99 as Float)
      apps.append(frozenApp)
      
      bestNewAppsCategory.apps = apps
      
      
      let bestNewGamesCategory = AppCategory()
      bestNewGamesCategory.name = "Best New Games"
      
      var bestNewGamesApps = [App]()
      
      let telepaintApp = App()
      telepaintApp.name = "Telepaint"
      telepaintApp.category = "Games"
      telepaintApp.imageName = "telepaint"
      telepaintApp.price = NSNumber(value: 2.99 as Float)
      
      bestNewGamesApps.append(telepaintApp)
      
      bestNewGamesCategory.apps = bestNewGamesApps
      
      return [bestNewAppsCategory, bestNewGamesCategory]
   }
}

// MARK: -

class App: NSObject {
   
   var id: NSNumber?
   var name: String?
   var category: String?
   var imageName: String?
   var price: NSNumber?
   
   var screenshots: [String]?
   var desc: String?
   var appInformation: AnyObject?
   
   override func setValue(_ value: Any?, forKey key: String) {
      if key == "description" {
         self.desc = value as? String
      } else {
         super.setValue(value, forKey: key)
      }
   }
}

*/
