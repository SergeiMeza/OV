
import SMKit

class ScreenshotsCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
   var app: App? {
      didSet {
         collectionView.reloadData()
      }
   }
   
   let collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      cv.backgroundColor = .clear
      return cv
   }()
   
   fileprivate let cellID = "cellID"
   
   let dividerLineView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
      return view
   }()
   
   override func setupViews() {
      super.setupViews()
      
      collectionView.dataSource = self
      collectionView.delegate = self
      
      contentView.addSubviews(collectionView, dividerLineView)
      
      collectionView.addAnchors(toTop: contentView.topAnchor, toRight: contentView.rightAnchor, toBottom: dividerLineView.topAnchor, toLeft: contentView.leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 0, bottomConstant: 0, width: 0, height: 0)
      
      dividerLineView.addAnchors(toTop: nil, toRight: contentView.rightAnchor, toBottom: contentView.bottomAnchor, toLeft: contentView.leftAnchor, topConstant: 0, rightConstant: 0, leftConstant: 14, bottomConstant: 0, width: 0, height: 1)
      
      collectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: cellID)
   }
   
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if let count = app?.screenshots?.count {
         return count
      }
      return 0
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScreenshotImageCell
      
      if let imageName = app?.screenshots?[indexPath.item] {
         cell.imageView.image = UIImage(named: imageName)
      }
      
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(width: 240, height: frame.height - 28)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0, 14, 0, 14)
   }
   
   fileprivate class ScreenshotImageCell: BaseCell {
      
      let imageView: UIImageView = {
         let iv = UIImageView()
         iv.contentMode = .scaleAspectFill
         iv.bg = .green
         return iv
      }()
      
      fileprivate override func setupViews() {
         super.setupViews()
         
         layer.masksToBounds = true
         
         contentView.addSubviews(imageView)
         
         imageView.fillSuperview()
      }
   }
}











































































