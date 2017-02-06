
import SMKit

struct ImageHelper {
   
   private let image0 = #imageLiteral(resourceName: "tutorial1")
   private let image1 = #imageLiteral(resourceName: "tutorial2")
   private let image2 = #imageLiteral(resourceName: "tutorial3")
   private let image3 = #imageLiteral(resourceName: "tutorial4")
   private let image4: UIImage? = nil
   
   let images : [UIImage?] // done
   
   init() {
      images = [
         image0,
         image1,
         image2,
         image3,
         image4
      ]
   } // done
} // done

class ImageController: UICollectionViewController {
   let cellID = "ImageCell" // done
   var pages : [Page] = [] // done
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.isUserInteractionEnabled = false
      setupCollectionView()
   } // done
   
   fileprivate func setupCollectionView() {
      collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: cellID)
      collectionView?.backgroundColor = .clear
      collectionView?.isPagingEnabled = true
      collectionView?.showsVerticalScrollIndicator = false
      collectionView?.showsHorizontalScrollIndicator = false
      collectionView?.isUserInteractionEnabled = false
   } // done
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return pages.count
   } // done
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
      return cell
   } // done
} // done

extension ImageController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return collectionView.bounds.size
   } // done
} // done

extension ImageController {
   override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      guard let cell = cell as? ImageCell else { return }
      cell.imageView.image = ImageHelper().images[indexPath.row]
   } // done
} // done

class ImageCell: BaseCell {
   
   let imageView : UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      return iv
   }() // done
   
   override func setupViews() {
      super.setupViews()
      contentView.addSubviews(imageView)
      
      Constraint.fillSuperview(with: imageView)
   } // done
} // done
