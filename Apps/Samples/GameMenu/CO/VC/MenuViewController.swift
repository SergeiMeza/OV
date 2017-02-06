//
//  MenuViewController.swift
//  GameMenu
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/06.
//  Copyright © 2017 OneVision. All rights reserved.
//


import SMKit

class MenuViewController: UIViewController {
   
   lazy var transitionDriver: TransitionDriver =  { [unowned self] in
      let td = TransitionDriver()
      td.delegate = self
      return td
      }()
   
   lazy var settingsButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.contentMode = .scaleAspectFit
      b.addTarget(self, action: #selector(settingsButtonUp), for: [.touchUpInside])
      return b
      }()
   
   lazy var startButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.contentMode = .scaleAspectFit
      b.addTarget(self, action: #selector(startButtonUp), for: [.touchUpInside])
      return b
      }()
   
   
   let stackview: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.alignment = .bottom
      sv.distribution = .fill
      sv.spacing = 4
      return sv
   }()
   
   lazy var themeButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.contentMode = .scaleAspectFit
      b.addTarget(self, action: #selector(themeButtonUp), for: [.touchUpInside])
      return b
      }()
   
   lazy var rankingButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.contentMode = .scaleAspectFit
      b.addTarget(self, action: #selector(rankingButtonUp), for: [.touchUpInside])
      return b
      }()
   
   lazy var gamecenterButton: SMButton01 = { [unowned self] in
      let b = SMButton01.init(type: .custom)
      b.contentMode = .scaleAspectFit
      b.addTarget(self, action: #selector(gamecenterButtonUp), for: [.touchUpInside])
      return b
      }()
   
   override var prefersStatusBarHidden: Bool {
      return true
   }
}

extension MenuViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setupTheme(currentTheme)
      setupNavigationController()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: true)
   }
   
   fileprivate func setupViews() {
      setupTheme(currentTheme)
      view.addSubviews(settingsButton, startButton , stackview)
      
      stackview.addArrangedSubviews(themeButton, rankingButton, gamecenterButton)
      
      setupConstraints()
      
   }
   
   private func setupConstraints() {
      
      settingsButton.addAnchors(toTop: settingsButton.superview!.topAnchor,
                                toLeft: settingsButton.superview!.leftAnchor,
                                topConstant: 8,
                                leftConstant: 8)
      
      startButton.anchorCenterToSuperView()
      startButton.addAnchors(width: 275/414*view.width, height: 275/414*view.width)
      
      
      if let imageView = settingsButton.imageView {
         if UIDevice.current.userInterfaceIdiom == .phone {
            imageView.addAnchors(width: 30/414*view.width, height: 30/414*view.width)
         } else {
            imageView.addAnchors(width: 60/1024*view.width, height: 60/1024*view.width)
         }
      }
      
      if let imageView = startButton.imageView {
         Constraint.make(imageView, .width, imageView, .height, 1, 0)
         //         if UIDevice.current.userInterfaceIdiom == .phone {
         //            Constraint.make(imageView, .width, .equal, 275/414*view.width) // square size
         //         } else {
         //            Constraint.make(imageView, .width, .equal, 550/1024*view.width) // square size
         //         }
      }
      
      if let imageView = themeButton.imageView {
         Constraint.make(imageView, .width, imageView, .height, 1, 0)
         if UIDevice.current.userInterfaceIdiom == .phone {
            Constraint.make(imageView, .width, .equal, 63.5/414*view.width) // square size
         } else {
            Constraint.make(imageView, .width, .equal, 120/1024*view.width) // square size
         }
      }
      
      if let imageView = rankingButton.imageView {
         Constraint.make(imageView, .width, imageView, .height, 1, 0)
         if UIDevice.current.userInterfaceIdiom == .phone {
            Constraint.make(imageView, .width, .equal, 63.5/414*view.width) // square size
         } else {
            Constraint.make(imageView, .width, .equal, 120/1024*view.width) // square size
         }
      }
      
      if let imageView = gamecenterButton.imageView {
         Constraint.make(imageView, .width, imageView, .height, 1, 0)
         if UIDevice.current.userInterfaceIdiom == .phone {
            Constraint.make(imageView, .width, .equal, 63.5/414*view.width) // square size
         } else {
            Constraint.make(imageView, .width, .equal, 120/1024*view.width) // square size
         }
      }
      
      if UIDevice.current.userInterfaceIdiom == .phone {
         stackview.spacing = 4
      } else {
         stackview.spacing = 10
      }
      
      
      Constraint.make(stackview, .centerX, superView: .centerX, 1, 0)
      Constraint.make(stackview, .bottom, superView: .bottom, 1, -8)
   }
   
   
}

extension MenuViewController {
   
   @objc fileprivate func settingsButtonUp() {
      let vc = SettingsViewController()
      setupSettingsTableViewController(vc)
      navigationController?.present(vc, animated: true)
   }
   
   private func setupSettingsTableViewController(_ vc: SettingsViewController) {
      vc.transitioningDelegate = transitionDriver
      vc.modalPresentationStyle = .custom
      transitionDriver.shadowOffset = .make(8, 12)
      transitionDriver.setupProperties(operation: .present,
                                       initialFrame: .init(insetXY: (view.w*0.1, view.h*0.12), offsetXY: (0, -view.h)),
                                       targetFrame: .init(insetXY: (view.w*0.1, view.h*0.12), offsetXY: (0, 0)),
                                       finalFrame: .init(insetXY: (view.w*0.1, view.h*0.12), offsetXY: (0, view.h)))
   }
   
   @objc fileprivate func startButtonUp() {
      let vc = ViewController()
      vc.view.bg = .white
      vc.navigationItem.title = "Game"
      transitionDriver.shadowOffset = .zero
      transitionDriver.setupProperties(operation: .push,
                                       initialFrame: .init(insetXY: (0,0), offsetXY: (-view.w,0)),
                                       targetFrame: .init(insetXY: (0, 0), offsetXY: (0, 0)),
                                       finalFrame: .init(insetXY: (0, 0), offsetXY: (-view.w, 0)))
      navigationController?.pushViewController(vc, animated: true)
   }
   
   @objc fileprivate func themeButtonUp() {
      let vc = ThemesViewController()
      transitionDriver.shadowOffset = .zero
      
      transitionDriver.setupProperties(operation: .push,
                                       initialFrame: .init(insetXY: (0, 0), offsetXY: (0, v.h)),
                                       targetFrame: .init(insetXY: (0, 0), offsetXY: (0, 0)),
                                       finalFrame: .init(insetXY: (0, 0), offsetXY: (0, v.h)))
      navigationController?.pushViewController(vc, animated: true)
   }
   
   @objc fileprivate func rankingButtonUp() {
      //      let vc = ViewController()
      let vc = TestViewController()
      transitionDriver.shadowOffset = .zero
      transitionDriver.setupProperties(operation: .push,
                                       initialFrame: .init(insetXY: (0,0), offsetXY: (0,v.h)),
                                       targetFrame: .init(insetXY: (0,0), offsetXY: (0,0)),
                                       finalFrame: .init(insetXY: (0,0), offsetXY: (0,v.h)))
      navigationController?.pushViewController(vc, animated: true)
   }
   
   @objc fileprivate func gamecenterButtonUp() {
      //      let vc = ViewController()
      let vc = OneVisionReviewViewController()
      transitionDriver.shadowOffset = .zero
      transitionDriver.setupProperties(operation: .push,
                                       initialFrame: .init(insetXY: (0,0), offsetXY: (0,v.h)),
                                       targetFrame: .init(insetXY: (0,0), offsetXY: (0,0)),
                                       finalFrame: .init(insetXY: (0,0), offsetXY: (0,v.h)))
      navigationController?.pushViewController(vc, animated: true)
   }
}

extension MenuViewController {
   
   fileprivate func setupNavigationController() {
      navigationController?.delegate = transitionDriver
   }
   
   public func setupTheme(_ currentTheme: Theme) {
      
      guard let colors = colors(currentTheme) else {
         return
      }
      view.backgroundColor = colors[ThemeColor.bg]
      
      startButton.setProperties(image: UIImage.init(named: "button_circle_large")!, title: "START", titleSize: 160,
                                color: colors[ThemeColor.btn]!,
                                titleColor: colors[ThemeColor.btnText]!,
                                shadowColor: colors[ThemeColor.btnShadow]!)
      
      themeButton.setProperties(image: #imageLiteral(resourceName: "pallete_small"), buttonImage: #imageLiteral(resourceName: "button_circle_small"),
                                color: colors[ThemeColor.btnClear]!,
                                buttonColor: colors[ThemeColor.btnDark]!,
                                shadowColor: colors[ThemeColor.btnShadow]!)
      
      gamecenterButton.setProperties(image: #imageLiteral(resourceName: "gamecenter_small"), buttonImage: #imageLiteral(resourceName: "button_circle_small"),
                                     color: colors[ThemeColor.btnClear]!,
                                     buttonColor: colors[ThemeColor.btnDark]!,
                                     shadowColor: colors[ThemeColor.btnShadow]!)
      
      
      rankingButton.setProperties(image: #imageLiteral(resourceName: "ranking_small"), buttonImage: #imageLiteral(resourceName: "button_circle_small"),
                                  color: colors[ThemeColor.btnClear]!,
                                  buttonColor: colors[ThemeColor.btnDark]!,
                                  shadowColor: colors[ThemeColor.btnShadow]!)
      
      settingsButton.setProperties(image: #imageLiteral(resourceName: "settings_small"), color: colors[ThemeColor.btnDark]!)
   }
}


class ViewController: UIViewController {
   override var prefersStatusBarHidden: Bool {
      return true
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(false, animated: true)
   }
   
   override func viewDidLoad() {
      view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapped)))
   }
   
   func tapped() {
      presentingViewController?.dismiss(animated: true, completion: nil)
      _ = navigationController?.popViewController(animated: true)
   }
   
   
}

extension MenuViewController: TransitionDriverDelegate {
   func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
      if let vc = viewController as? MenuViewController {
         vc.setupTheme(currentTheme)
      }
   }
}
