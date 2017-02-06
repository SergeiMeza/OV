//
//  OneVisionApptoreDatasource.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import Foundation

internal class OneVisionApptoreDatasource: TableViewDatasource {
   
   override init() {
      super.init()
      
      objects = OneVision.Company.apps
   }
   
   override func cellClasses() -> [DatasourceTableViewCell.Type] {
      return [OneVisionApptoreCell.self]
   }
}
