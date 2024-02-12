//Created by IPH Technologies Pvt. Ltd.

import UIKit

//struct ImageData {
//    let imageName: String
//    let title: String
//}
class ImageViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    
    var selectedFoodName: String?
    //var imageData: ImageData?
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Set navigationController to nil to show the back button
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let data = imageData else {
//            return
//        }
        itemImage.image = UIImage(named: imageArray[currentIndex])
        itemNameLbl.text = imageArray[currentIndex]
        
    }
    


}
