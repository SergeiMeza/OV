
import UIKit
import StoreKit

class BuyDriver: NSObject {
   
   weak var shop: ShopDriver!
   weak var pageHelper: PageHelper!
   weak var restore: RestoreDriver!
   
   weak var vc: UIViewController!
   
   var transactionInProgress = false
}

extension BuyDriver {
   
   func setupController() {
      shop.delegate = self
      restore.delegate = self
   }
}

extension BuyDriver: ShopDriverDelegate {
   
   func buyButtonTapped(_ button: UIButton) {
      restore.restorePurchases()
   }
}

extension BuyDriver: SKProductsRequestDelegate {
   
   func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
      if response.products.count != 0 {
         for product in response.products {
            productsArray.append(product)
         }
         startBuying()
         return
      } else {
         vc.presentAlert(errorString, okHandler: { [unowned self] _ in
            self.handleCancelAction()
         })
      }
   }
}


extension BuyDriver: SKPaymentTransactionObserver {
   
   func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      if transactions.count == 1 {
         for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: handleBuyAction()
            case .failed: handleCancelAction()
            default: break
            }
         }
      }
   }
}

extension BuyDriver: RestoreDriverDelegate {
   
   func handleRestoreAction() {
      shop.handleAnimation()
      pageHelper.limitIndex = 10000
      shop.isActive = false
      comprado = true
      SKPaymentQueue.default().remove(self)
   }
   
   func handleRestoreFailedAction() {
      SKPaymentQueue.default().add(self)
      requestProductInfo()
   }
}

extension BuyDriver {
   
   func requestProductInfo() {
      if SKPaymentQueue.canMakePayments() {
         if productsArray.isEmpty {
            let productIdentifiers = NSSet(array: productIds)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
         } else {
            startBuying()
         }
      } else {
         vc.presentAlert(iAPNotAllowedMessage, okHandler: { [unowned self] _ in
            self.handleCancelAction()
         })
      }
   }
   
   
   fileprivate func startBuying() {
      if let product = productsArray.first {
         let payment = SKPayment(product: product)
         SKPaymentQueue.default().add(payment)
         transactionInProgress = true
      }
   }
   
   fileprivate func handleCancelAction() {
      transactionInProgress = false
      shop.cancelBuy()
      comprado = false
      SKPaymentQueue.default().remove(self)
   }
   
   fileprivate func handleBuyAction() {
      shop.handleAnimation()
      pageHelper.limitIndex = 10000
      shop.isActive = false
      comprado = true
      SKPaymentQueue.default().remove(self)
   }
}


