//Created by IPH Technologies Pvt. Ltd.

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
    }
    

}
