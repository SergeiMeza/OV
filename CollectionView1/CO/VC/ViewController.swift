
import SMKit

class SmartDatasource: CollectionViewDatasource {
   
   override init() {
      super.init()
      
      objects = ["Hello World",
               "Hello World\nHelloWorld\nHelloWorld",
               "Hello World\nHelloWorld\nHelloWorld\nHello World\nHelloWorld\nHelloWorld"
      ]
   }
}

class SmartCollectionViewController: DatasourceCollectionViewController {
   
   override init() {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical
      layout.estimatedItemSize = .init(width: UIApplication.shared.keyWindow!.frame.width, height: 44)
      layout.minimumLineSpacing = 10
      super.init(collectionViewLayout: layout)
      
      datasource = SmartDatasource()
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
//      layout?.estimatedItemSize = .init(width: 44, height: 44) // will crash with loop
      
      title = "Smart Collection View"
      
      collectionView?.bg = UIColor.init(white: 0.9, alpha: 1)
   }
   
   override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      cell.contentView.bg = .white
      
   }
}
