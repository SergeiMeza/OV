
import UIKit
import StoreKit

class MenuRestoreDriver: NSObject {
   
   weak var menuVC: MenuViewController? {
      didSet {
         menuVC?.delegate = self
      }
   }
   
   deinit {
      SKPaymentQueue.default().remove(self)
   }
   
}

extension MenuRestoreDriver: MenuViewControllerDelegate {
   
   func restorePurchases() {
      if SKPaymentQueue.canMakePayments() {
         SKPaymentQueue.default().add(self)
         SKPaymentQueue.default().restoreCompletedTransactions()
      }
   }
}

extension MenuRestoreDriver: SKPaymentTransactionObserver {
   
   func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      for transaction in transactions {
         if transaction.payment.productIdentifier == productIds.first! {
            let state = transaction.transactionState.rawValue
            if state == 3 || state == 1 {
               comprado = true
            }
         }
      }
   }
   
   func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
      menuVC?.activityIndicator.stopAnimating()
      menuVC?.restoreButton.isEnabled = true
      menuVC?.restoreButton.alpha = 1.0
      menuVC?.restoring = false
      menuVC?.activityIndicator.stopAnimating()
      
      menuVC?.presentAlert(error.localizedDescription)
      SKPaymentQueue.default().remove(self)
   }
   
   func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
      menuVC?.activityIndicator.stopAnimating()
      menuVC?.restoreButton.isEnabled = true
      menuVC?.restoreButton.alpha = 1.0
      menuVC?.restoring = false
      menuVC?.activityIndicator.stopAnimating()
      
      SKPaymentQueue.default().remove(self)
      
      if comprado {
         let vc = UIAlertController(title: "", message: restoreString, preferredStyle: .alert)
         let okAction = UIAlertAction(title: ok, style: .cancel, handler: nil)
         vc.addAction(okAction)
         menuVC?.present(vc, animated: true, completion: nil)
      } else {
         let vc = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
         let okAction = UIAlertAction(title: ok, style: .cancel, handler: nil)
         vc.addAction(okAction)
         menuVC?.present(vc, animated: true, completion: nil)
      }
   }
}
