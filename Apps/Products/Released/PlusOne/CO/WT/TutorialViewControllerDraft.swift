
import UIKit

class TutorialViewControllerDraft: UIViewController {
   
   var pages : [Page] = [] {
      didSet {
         collectionVC.pages = pages
         imageController.pages = pages
         pageControl.numberOfPages = pages.count
         collectionVC.collectionView?.reloadData()
         imageController.collectionView?.reloadData()
      }
   } // done

   var pageControlBotttomAnchorConstraint: Constraint = Constraint() // done
   
   let pageControl : UIPageControl = {
      let pc = UIPageControl()
      pc.pageIndicatorTintColor = UIColor(white: 0.5, alpha: 1)
      pc.currentPageIndicatorTintColor = ._black
      pc.defersCurrentPageDisplay = true
      pc.isUserInteractionEnabled = false
      pc.alpha = 0
      return pc
   }() // done
   
   let collectionVC : CollectionViewControllerDraft = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      let cvc = CollectionViewControllerDraft(collectionViewLayout: layout)
      return cvc
   }() // done

   let imageController: ImageController = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      let ic = ImageController(collectionViewLayout: layout)
      return ic
   }() // done
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setPages()
      setupPageControl()
      setupCollectionView()
      setupImageController()
   } // done
   
   func setPages() {
      
   } // done
   
   func setupPageControl() {
      view.backgroundColor = .white
      view.addSubviews(pageControl)
      
      let metrics = ["vs": 16, "pcw":150, "pch": 37]
      
      Constraint.make(pageControl, .centerX, .equal, view, .centerX, 1, 0)
      
      Constraint.make("H:[v0(pcw)]", metrics: metrics, views: pageControl)
      Constraint.make("V:[v0(pch)]", metrics: metrics, views: pageControl)
      
      pageControlBotttomAnchorConstraint = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
      pageControlBotttomAnchorConstraint.isActive = true
   } // done
   
   fileprivate func setupCollectionView() {
      
      view.insertSubview(collectionVC.view, at: 0)
      
      Constraint.extend(collectionVC.view)
      
      collectionVC.delegate = self
   } // done
   
   func setupImageController() {
      view.addSubview(imageController.view)
      
      let metrics = ["icw": view.width, "ich": view.height*0.50]
      
      Constraint.make("H:|[v0(icw)]|", metrics: metrics, views: imageController.view)
      Constraint.make("V:[v0(ich)]", metrics: metrics, views: imageController.view)
      Constraint.make(imageController.view, .centerX, .equal, view, .centerX, 1, 0)
      imageController.view.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 16).isActive = true
   } // done
   
} // done

extension TutorialViewControllerDraft: PageControllerDelegate {

   func pageIndexDidChange(to index: Int) {
      pageControl.currentPage = index
      if let pip = imageController.collectionView?.indexPathsForVisibleItems.first {
         if pip.row != index-1 {
            let deadlineTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [unowned self] in
               let ip = IndexPath(row: index-1, section: 0)
               if ip.row >= 0 && ip.row <= 3 {
                  self.imageController.collectionView?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
               }
            }
         }
      }
   } // done
   
   func willMove(to index: Int) {
      if index >= 1 && index <= 4 {
         let ip = IndexPath(row: index-1, section: 0)
         imageController.collectionView?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
      }
   } // done
      
   func didScroll(_ offset: CGFloat, page: Int) {
      
      if page == 0 {
         var mutableOffset = offset
         mutableOffset = mutableOffset*0.85 - 1
         pageControl.alpha = mutableOffset
         if mutableOffset >= 0.95 {
            pageControl.alpha = 1
         }
      } // fade in page control
      
      if page == 0 {
         var mutableOffset = offset
         mutableOffset = (mutableOffset - 1) // fadein when moving current to next page (0->1)
         pageControlBotttomAnchorConstraint.constant = min(-16, max(-mutableOffset*view.height*0.5-16, -view.height*0.5-16))
         if mutableOffset >= 0.95 {
            pageControlBotttomAnchorConstraint.constant = -view.height*0.5-16
         }
         
         if mutableOffset <= 0.05 {
            pageControlBotttomAnchorConstraint.constant = -16
         }
      } // move page control and image controller up
      
      if page == 4 {
         var mutableOffset = offset
         mutableOffset = 1.0 + (1.0 - mutableOffset) // fadeout when moving current to next page (1->0)
         pageControlBotttomAnchorConstraint.constant = min(-16, max(-mutableOffset*view.height*0.5-16, -view.height*0.5-16))
         
         if mutableOffset <= 0.05 {
            pageControlBotttomAnchorConstraint.constant = -16
         }
         
         if mutableOffset >= 0.95 {
            pageControlBotttomAnchorConstraint.constant = -view.height*0.5-16
         }
         
      } // move page control and image controller down
   } // debugging
   
} // done

extension TutorialViewControllerDraft: PageDelegate {
   
   func moveToNextPage() {
      collectionVC.tapped()
   }
   
   func finalizeTutorial() {
      presentingViewController?.dismiss(animated: true, completion: nil)
   }
}

