
import UIKit
import StoreKit

class RestoreDriver : NSObject {
   
   weak var delegate : RestoreDriverDelegate?
   
   weak var vc: UIViewController!
   
   weak var button: UIButton! {
      didSet{
         button.addTarget(self, action:#selector(restorePurchases), for: [.touchUpInside, .touchUpOutside])
      }
   }
   
   deinit {
      SKPaymentQueue.default().remove(self)
   }
}

extension RestoreDriver {
   
   func restorePurchases() {
      if SKPaymentQueue.canMakePayments() {
         SKPaymentQueue.default().add(self)
         SKPaymentQueue.default().restoreCompletedTransactions()
      }
   }
   
   fileprivate func createOkAlertControllerWith(message: String) -> UIAlertController {
      let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: ok, style: .cancel, handler: nil)
      alertVC.addAction(okAction)
      return alertVC
   }
}

extension RestoreDriver: SKPaymentTransactionObserver {
   
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
      let alertVC = createOkAlertControllerWith(message: error.localizedDescription)
      vc.present(alertVC, animated: true, completion: {
         self.delegate?.handleRestoreFailedAction?()
      })
      SKPaymentQueue.default().remove(self)
   }
   
   func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
      SKPaymentQueue.default().remove(self)
      if comprado {
         vc.presentAlert(restoreString, okHandler: { [unowned self] _ in
            self.delegate?.handleRestoreAction?()
         })   
      } else {
         delegate?.handleRestoreFailedAction?()
      }
   }
}

@objc protocol RestoreDriverDelegate : class
{
   @objc optional func handleRestoreAction()
   @objc optional func handleRestoreFailedAction()
}
