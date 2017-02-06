//
//  ViewController.swift
//  SMKit-TemplateApp
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//

import SMKit

class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
     
      title = "HomeViewController"
      
      view.bg = .white
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(aboutTapped))
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", style: .plain, target: self, action: #selector(reviewTapped))
   }
}

extension ViewController {

   func aboutTapped() {
      let vc = OneVisionAboutViewController()
      navigationController?.pushViewController(vc, animated: true)
   }
   
   func reviewTapped() {
      let vc = OneVisionReviewViewController()
      navigationController?.pushViewController(vc, animated: true)
   }
   
}
