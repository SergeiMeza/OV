//
//  VCs.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

let data : [Any] = []




class ThemesViewController: SMBaseTableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      logger.log(value: "Presenting ThemesViewController")
      
      setupProperties(myThemes)
      setupProperties(tableviewTitle: "THEMES", myCellClass: SMCustomTableViewCell01.self)
      _headerView.leftButton.isHidden = true
      _headerView.rightButton.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .rgb(0x1F1F1F))
      
      Constraint.make(_headerView.rightButton.imageView!, .width, _headerView.rightButton.imageView, .height, 1, 0)
      Constraint.make(_headerView.rightButton.imageView!, .width, .equal, 25)
      
      if UIDevice.current.userInterfaceIdiom == .phone {
         _tableView.rowHeight = (view.height-44)/7
      } else {
         _tableView.rowHeight = (view.height-44)/14
      }
   }
   
   override func setupCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
      if let cell = cell as? SMCustomTableViewCell01 {
         cell.titleLabel.text = myThemes[indexPath.row].rawValue.uppercased()
         cell.contentView.bg = colors(myThemes[indexPath.row])?[ThemeColor.bg]
         cell.titleLabel.textColor = colors(myThemes[indexPath.row])?[ThemeColor.string]
         
         if UIDevice.current.userInterfaceIdiom == .phone {
            cell.titleLabel.font = UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 28)
         } else {
            cell.titleLabel.font = UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 40)
         }
         
         cell.titleLabel.scaleXBy(0.9)
         
         
         cell.rightImageView.image = #imageLiteral(resourceName: "check_small")
      }
   }
   
   func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      currentTheme = myThemes[indexPath.row]
      return false
   }
}

let settingsCategories = ["MUSIC", "SOUND EFFECTS", "COLORBLIND MODE", "REMOVE ADS", "RESTORE MY PURCHASES"]

class SettingsViewController: SMBaseTableViewController {
   
   let transitionDriver : TransitionDriver = {
      let td = TransitionDriver.init()
      td.delegate = nil
      return td
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      logger.log(value: "Presenting SettingsViewController")
      
      setupProperties(settingsCategories)
      setupProperties(tableviewTitle: "SETTINGS", myCellClass: SMCustomTableViewCell02.self)
      
      _headerView.leftButton.setTitle("info", for: .normal)
      _headerView.leftButton.setTitleColor(.black, for: .normal)
      
      _headerView.rightButton.setProperties(image: #imageLiteral(resourceName: "exit_small"), color: .rgb(0x1F1F1F))
      
      _tableView.isScrollEnabled = false
      _tableView.rowHeight = (view.height - 44)*0.76/CGFloat(settingsCategories.count)
      
      Constraint.make(_headerView.rightButton.imageView!, .width, _headerView.rightButton.imageView, .height, 1, 0)
      Constraint.make(_headerView.rightButton.imageView!, .width, .equal, 20)
   }
   
   override func setupCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
      if let cell = cell as? SMCustomTableViewCell02 {
         cell.contentView.bg = .white
         cell.titleLabel.text = "\(settingsCategories[indexPath.row])"
         cell.titleLabel.textColor = .black
         
         if indexPath.row == settingsCategories.count-1 {
            cell.contentView.bg = UIColor.init(white: 0.90, alpha: 1)
            cell.textLabel?.bg = UIColor.init(white: 0.90, alpha: 1)
            cell.titleLabel.textAlignment = .center
         }
      }
   }
   
   func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   
   override func leftButtonAction() {
      let vc = OneVisionAboutViewController()
      vc.transitioningDelegate = transitionDriver
      vc.modalPresentationStyle = .custom
      
      transitionDriver.setupProperties(operation: .present,
                                       initialFrame: .init(insetXY: (0,0), offsetXY: (0,-v.h)),
                                       targetFrame: .init(insetXY: (0,0), offsetXY: (0,0)),
                                       finalFrame: .init(insetXY: (0,0), offsetXY: (0, v.h/0.76)),  shadowAlpha: 0, dimmingAlpha: 0)
      present(vc, animated: true, completion: nil)
   }
   
   override func rightButtonAction() {
      presentingViewController?.dismiss(animated: true, completion: nil)
      _ = navigationController?.popViewController(animated: true)
   }
}








