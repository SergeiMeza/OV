//
//  OneVisionController.swift
//  SMKit
//
//  Created by Jeany Sergei Meza Rodriguez on 2017/01/05.
//  Copyright © 2017 OneVision. All rights reserved.
//

import UIKit
import StoreKit
import Accounts
import Social
import MessageUI

internal protocol OneVisionControllerDelegate: class {
   func appReview(_ isCompleted: Bool)
}

/** add this controller to some UIViewController to delegate functionallity
 
   Features:
      - review apps
      - show apps
      - follow on Twitter
      - send email
 
   Usage:
      -
 
 
 */
internal class OneVisionController: NSObject, SKStoreProductViewControllerDelegate, MFMailComposeViewControllerDelegate {
   
   weak var delegate: OneVisionControllerDelegate?
   weak var viewController: UIViewController?
   
   func setupProperties(viewController vc: UIViewController) {
      viewController = vc
   }
}


// AppStore Methods - review && - showOnStore
extension OneVisionController {
   
   func reviewThisApp(completion: (()->())? = nil) {
      let urlString = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(OneVision.App.appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
      
      UIApplication.shared.open(URL.init(string: urlString)!, options: [:], completionHandler: { [unowned self] _ in
         completion?()
         self.delegate?.appReview(true)
      })
   }
   
   
   /// Comment: solo puede presentar una app a la vez... (presentar una tableview primero y luego utilizar este metodo... >___<)
   func showAppOnStore(_ appID: String?) {
      guard let appID = appID else {
         self.viewController?.presentAlert(OneVision.ErrorMessages.tryAgain)
         return
      }
      
      let storeViewController = SKStoreProductViewController.init()
      let parameter: [String:String] = [SKStoreProductParameterITunesItemIdentifier: appID]
      
      storeViewController.loadProduct(withParameters: parameter, completionBlock: nil)
      storeViewController.delegate = self
      
      viewController?.present(storeViewController, animated: true, completion: nil)
   }
   
}

// Twitter - Follow
extension OneVisionController {

   func followOnTwitter() {
      
      let accountStore = ACAccountStore.init()
      let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
      
      accountStore.requestAccessToAccounts(with: accountType, options: nil) {
         [unowned self] (granted, error) in
         
         guard granted else {
            self.viewController?.presentAlert(OneVision.Messages.twitterAccess)
            return
         }
         
         guard error == nil else {
            self.viewController?.presentAlert(OneVision.ErrorMessages.followTryAgain)
            return
         }
         
         if let accounts = accountStore.accounts(with: accountType) {
            if accounts.count > 0 {
               for account in accounts {
                  let parameters: [String: Any] = ["screen_name": OneVision.Company.OVTwitterAccount, "follow": true]
                  
                  let postRequest = SLRequest.init(forServiceType: SLServiceTypeTwitter,
                                                   requestMethod: .POST,
                                                   url: URL.init(string: "https://api.twitter.com/1.1/friendships/create.json"),
                                                   parameters: parameters)
                  postRequest?.account = (account as! ACAccount)
                  postRequest?.perform(handler: {
                     [unowned self] (data, response, error) in
                     if (account as! ACAccount) == (accounts.last! as! ACAccount) {
                        if response?.statusCode == 200 {
                           self.viewController?.presentAlert(OneVision.Messages.followThanks)
                        } else {
                           self.viewController?.presentAlert(OneVision.ErrorMessages.followTryAgain)
                        }
                     }
                  })
               }
            } else {
               self.viewController?.presentAlert(OneVision.Messages.twitterAccess)
            }
         }
      }
   }
   
}
// UserEmail - subsribe && - contact
extension OneVisionController {

   func subscribe() {
      let subscribeAlert = UIAlertController.init(title: "", message: "Get the latest updates about our apps", preferredStyle: .alert)
      let cancelAction = UIAlertAction.init(title: OneVision.Messages.cancel, style: .cancel, handler: nil)
      let subscribeAction = UIAlertAction.init(title: OneVision.Messages.subscribe, style: .default, handler: {
         [unowned self] (action) in
         if let email = subscribeAlert.textFields?[0].text {
            userMail = email
            self.viewController?.presentAlert("Thanks! Your email address has been added to our list.")
         }
      })
      
      subscribeAlert.addTextField { (textfield) in
         textfield.placeholder = "me.@example.com"
         textfield.keyboardType = .emailAddress
      }
      
      subscribeAlert.addAction(cancelAction)
      subscribeAlert.addAction(subscribeAction)
      
      self.viewController?.present(subscribeAlert, animated: true, completion: nil)
   }

   func contactUs() {
      
      let mail = MFMailComposeViewController()
      mail.setToRecipients(["\(OneVision.Company.contactEmail)"])
      mail.setSubject("[\(OneVision.App.appName) \(OneVision.App.version)]")
      mail.setMessageBody("", isHTML: false)
      
      mail.mailComposeDelegate = self
      if MFMailComposeViewController.canSendMail() {
         self.viewController?.present(mail, animated: true, completion: nil)
      } else {
         self.viewController?.presentAlert(OneVision.ErrorMessages.contactUs)
      }
      
   }
   
}

extension OneVisionController {
   
   func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
      viewController.dismiss(animated: true, completion: nil)
   }
}

extension OneVisionController {
   
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.presentingViewController?.dismiss(animated: true, completion: nil)
   }
}

