//
//  Datasource.swift
//  Components
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/02.
//  Copyright © 2017 OneVision. All rights reserved.
//

import Foundation


/// CollectionViewDatasource is the object that provides your DatasourceController with the information it needs to render out a list. Override the methods in this class to provide a custom implementation of what cells/headers/footers your list should render.
open class CollectionViewDatasource: NSObject {
   
   public var objects: [Any]?
   
   
   /// The cell classes that will be used to render out each section.
   open func cellClasses() -> [DatasourceCollectionViewCell.Type] {
      return []
   }

   
   /// If you want more fine tuned control per row, override this method to provide the proper cell type that should be rendered
   open func cellClass(_ indexPath: IndexPath) -> DatasourceCollectionViewCell.Type? {
      return nil
   }
   
   
   /// Override this method to provide your list with what kind of headers should be rendered per section
   open func headerClasses() -> [DatasourceCollectionViewCell.Type]? {
      return []
   }
   
   /// Override this method to provide your list with what kind of footers should be rendered per section
   open func footerClasses() -> [DatasourceCollectionViewCell.Type]? {
      return []
   }
   
   open func numberOfItems(_ section: Int) -> Int {
      return objects?.count ?? 0
   }
   
   open func numberOfSections() -> Int {
      return 1
   }
   
   
   /// For each row in your list, override this to provide it with a specific item. Access this in your DatasourceCell by overriding datasourceItem
   open func item(_ indexPath: IndexPath) -> Any? {
      return objects?[indexPath.item]
   }
   
   
   /// If your headers need a special item, return it here.
   open func headerItem(_ section: Int) -> Any? {
      return nil
   }
   
   /// If your footers need a special item, return it here.
   open func footerItem(_ section: Int) -> Any? {
      return nil
   }
}
