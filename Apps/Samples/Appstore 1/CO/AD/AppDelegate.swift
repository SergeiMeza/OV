
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      window = UIWindow()
      window?.makeKeyAndVisible()
      
      let layout = UICollectionViewFlowLayout()
      let featuredAppsController = FeaturedAppsController(collectionViewLayout: layout)
      window?.rootViewController = UINavigationController(rootViewController: featuredAppsController)
      
      return true
   }
}
