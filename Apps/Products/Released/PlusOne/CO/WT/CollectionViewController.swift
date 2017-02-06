
import UIKit

@objc protocol PageControllerDelegate:class {
   @objc optional func pageIndexDidChange(to index: Int)
   @objc optional func didScroll(_ offset: CGFloat, page: Int)
   @objc optional func willMove(to index: Int)
} // done

class CollectionViewControllerDraft: UICollectionViewController {
   
   let cellID = "cell" // done
   
   var pages : [Page] = [] // done
   
   var currentIndex = 0 {
      didSet {
         delegate?.pageIndexDidChange?(to: currentIndex)
      }
   } // done
   
   weak var delegate: PageControllerDelegate? // done
   weak var prevPageDelegate: PageControllerDelegate? // done
   weak var currentPageDelegate: PageControllerDelegate? // done
   weak var nextPageDelegate: PageControllerDelegate? // done
   
   fileprivate func getPrevIndexPath() -> IndexPath? {
      let ip = collectionView?.indexPathForItem(at:  CGPoint.make(-view.bounds.centerX + CGFloat(currentIndex) * view.width, view.bounds.center.y))
      return ip
   } // done
   
   fileprivate func getNextIndexPath() -> IndexPath? {
      let ip = collectionView?.indexPathForItem(at:  CGPoint.make(-view.bounds.centerX + CGFloat(currentIndex + 2) * view.width, view.bounds.center.y))
      return ip
   } // done
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupCollectionView()
      attachTap(to: collectionView!)
   }  // done
   
   fileprivate func setupCollectionView() {
      collectionView?.register(PageCell.self, forCellWithReuseIdentifier: cellID)
      collectionView?.isPagingEnabled = true
      collectionView?.showsVerticalScrollIndicator = false
      collectionView?.showsHorizontalScrollIndicator = false
      collectionView?.backgroundColor = .clear
   } // done
   
   var tap: UITapGestureRecognizer!
   
   fileprivate func attachTap(to view: UIView) {
      tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
      view.addGestureRecognizer(tap)
   }
   
   func tapped() {
      if currentIndex <= pages.count-2 {
         let ip = IndexPath(row: currentIndex+1, section: 0)
         collectionView?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
         currentIndex += 1
      } else {
         
      }
      
   }
} // done

extension CollectionViewControllerDraft {
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return pages.count
   } // done
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PageCell
      return cell
   } // done
   
   override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let cell = cell as? PageCell {
         if let vc = pages[indexPath.row].vc {
            cell.contentViewController = vc
            if let vc = vc as? PageControllerDelegate {
               currentPageDelegate = vc
            }
         }
      }
   } // set up delegates
   
   override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let prevIP = getPrevIndexPath() {
         if let cell = collectionView.cellForItem(at: prevIP) as? PageCell {
            if let vc = cell.contentViewController as? PageControllerDelegate {
               prevPageDelegate = vc
            }
         }
      }
      if let nextIP = getNextIndexPath() {
         if let cell = collectionView.cellForItem(at: nextIP) as? PageCell {
            if let vc = cell.contentViewController as? PageControllerDelegate {
               nextPageDelegate = vc
            }
         }
      }
   } // set up delegates
} // done. Handle delegates

extension CollectionViewControllerDraft {
   
   /// passes a standarized value for each page in order to animate along scrolling
   
   override func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
      for i in 0...pages.count-1 {
         
         // current page starts at 1.
         // when moving to next page it changes along the scrolling to 2
         // when moving to previous page it changes along the scrolling to 0
         
         // next page starts at 0.
         // when moving to current page it changes along the scrolling to 1
         
         // previus page starts at 2.
         // when moving to current page it changes along the scrolling to 1
         
         let offsetX = ((scrollView.contentOffset.x + view.boundsWidth) - (view.boundsWidth * CGFloat(i))) / view.boundsWidth
         
         if (offsetX < 2.0 && offsetX > -2.0) {
            delegate?.didScroll?(offsetX, page: i)
            prevPageDelegate?.didScroll?(offsetX, page: i)
            currentPageDelegate?.didScroll?(offsetX, page: i)
            nextPageDelegate?.didScroll?(offsetX, page: i)
         }
      }
   } // done
   
   
   override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      delegate?.willMove?(to: Int(targetContentOffset.pointee.x/view.bounds.width))
   } // done
   
   override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      currentIndex = Int((collectionView!.contentOffset.x+collectionView!.frameWidht/2)/collectionView!.frameWidht)
   } // done
} // done

extension CollectionViewControllerDraft: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return collectionView.bounds.size
   } // done
} // done
