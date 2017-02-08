//
//  DatasourceController.swift
//  Components
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/02.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit


/// DatasourceCollectionViewController is simply a UICollectionViewController that allows you to quickly create list views. In order to render out items in your list, simply provide it with a Datasource object.
open class DatasourceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
   open let activityIndicatorView: UIActivityIndicatorView = {
      let aiv = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
      aiv.hidesWhenStopped = true
      aiv.color = .black
      return aiv
   }()
   
   open var datasource: CollectionViewDatasource? {
      didSet {
         if let cellClasses = datasource?.cellClasses() {
            for cellClass in cellClasses {
               collectionView?.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
            }
         }
         
         if let headerClasses = datasource?.headerClasses() {
            for headerClass in headerClasses {
               collectionView?.register(headerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(headerClass))
            }
         }
         
         if let footerClasses = datasource?.footerClasses() {
            for footerClass in footerClasses {
               collectionView?.register(footerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(footerClass))
            }
         }
         
         collectionView?.reloadData()
      }
   }
   
   public init() {
      super.init(collectionViewLayout: UICollectionViewFlowLayout())
   }
   
   public override init(collectionViewLayout layout: UICollectionViewLayout) {
      super.init(collectionViewLayout: layout)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   let defaultCellId  = "meza_defaultCellId"
   let defaultFooterId = "meza_defaultFooterId"
   let defaultHeaderId = "meza_defaultHeaderId"
   
   override open func viewDidLoad() {
      super.viewDidLoad()
      collectionView?.backgroundColor = .white
      collectionView?.alwaysBounceVertical = true
      
      view.addSubview(activityIndicatorView)
      Constraint.center(activityIndicatorView)
      
      collectionView?.register(DefaultCell.self, forCellWithReuseIdentifier: defaultCellId)
      collectionView?.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: defaultHeaderId)
      collectionView?.register(DefaultFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: defaultFooterId)
   }
   
   open override func numberOfSections(in collectionView: UICollectionView) -> Int {
      return datasource?.numberOfSections() ?? 0
   }
   
   open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return datasource?.numberOfItems(section) ?? 0
   }
   
   open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell: DatasourceCollectionViewCell
      
      if let cls = datasource?.cellClass(indexPath) {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceCollectionViewCell
      } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
         let cls = cellClasses[indexPath.section]
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceCollectionViewCell
      } else if let cls = datasource?.cellClasses().first {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceCollectionViewCell
      } else {
         cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellId, for: indexPath) as! DatasourceCollectionViewCell
      }
      
      cell.controller = self
      cell.datasourceItem = datasource?.item(indexPath)
      return cell
   }
   
   open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
      let reusableView: DatasourceCollectionViewCell
      
      if kind == UICollectionElementKindSectionHeader {
         if let classes = datasource?.headerClasses(), classes.count > indexPath.section {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(classes[indexPath.section]), for: indexPath) as! DatasourceCollectionViewCell
         } else if let cls = datasource?.headerClasses()?.first {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceCollectionViewCell
         } else {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultHeaderId, for: indexPath) as! DatasourceCollectionViewCell
         }
         reusableView.datasourceItem = datasource?.headerItem(indexPath.section)
         
      } else {
         if let classes = datasource?.footerClasses(), classes.count > indexPath.section {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(classes[indexPath.section]), for: indexPath) as! DatasourceCollectionViewCell
         } else if let cls = datasource?.footerClasses()?.first {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(cls), for: indexPath) as! DatasourceCollectionViewCell
         } else {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultFooterId, for: indexPath) as! DatasourceCollectionViewCell
         }
         reusableView.datasourceItem = datasource?.footerItem(indexPath.section)
      }
      
      reusableView.controller = self
   
      return reusableView
   }
   
   open func getRefreshControl() -> UIRefreshControl {
      let rc = UIRefreshControl()
      rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
      return rc
   }
   
   open func handleRefresh() {
      
   }
   
   open var layout: UICollectionViewFlowLayout? {
      get {
         return collectionViewLayout as? UICollectionViewFlowLayout
      }
   }
}

