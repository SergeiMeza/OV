
import UIKit

struct Page { let vc: UIViewController? } // done

struct TutorialHelper {
   
   var pages: [Page] // done
   init() {
      
      let page0 = Page0()
      let page1 = Page1()
      let page2 = Page2()
      let page3 = Page3()
      let page4 = Page4()
      let page5 = Page5()
      
      pages = [
         Page(vc: page0),
         Page(vc: page1),
         Page(vc: page2),
         Page(vc: page3),
         Page(vc: page4),
         Page(vc: page5),
      ]
   } // done
} // done

class TutorialViewController: TutorialViewControllerDraft {
   override func setPages() {
      
      let helper = TutorialHelper()
      
      
      let page0 = helper.pages[0]
      let page1 = helper.pages[1]
      let page2 = helper.pages[2]
      let page3 = helper.pages[3]
      let page4 = helper.pages[4]
      let page5 = helper.pages[5]
      
      if let vc = page5.vc as? Page5 {
         vc.delegate = self
      }
      
      pages = [page0, page1, page2, page3, page4, page5]
   }
} // done
