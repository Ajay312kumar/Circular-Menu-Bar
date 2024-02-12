//
//  ViewController.swift
//  LeftSideMenu
//
//  Created by iPHTech40 on 22/05/23.
//

import UIKit
import LNSideMenu

//MARK: Protocol
protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

var imageArray = ["iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","Grape","iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","grapes","burger","mango","papaya","apple","iceCream","Grape","iceCream","grapes","burger","mango","papaya","apple"]


var currentIndex = 0

class SideMenuViewController: UIViewController, UIGestureRecognizerDelegate{
    
    //MARK: IBOutlets
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var itemTableView: UITableView!
    
    //MARK: Variable
    var foodListArray = [Food]()
    var count = 1
    var selectedIndexPath: IndexPath?
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0
    var isLoadingData = false
 
    let infoImageView = UIImageView(frame: CGRect(x: 0, y: 200, width: 400, height: 300))
    let infoLabel = UILabel(frame: CGRect(x: 5, y: 500, width: 400, height: 100))
 
    
    //MARK: Life cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///without scrolling toggle button will work
      // navigationController?.setNavigationBarHidden(true, animated: true)
        
        infoImageView.image = UIImage(named: "default")
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.backgroundColor = .clear
        view.addSubview(infoImageView)
        
        infoLabel.text = "Please select Item !"
        infoLabel.textColor = UIColor.red
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.textAlignment = .center
        view.addSubview(infoLabel)

        loadMoreData()
        setUpUIComponents()
        
        foodListArray = Food.defaultFoodList()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.allowsSelection = true
        itemTableView.isUserInteractionEnabled = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.isHidden = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
      
    }
    
    //MARK: IBOutlets
    @IBAction func hideShowBtn(_ sender: Any) {
        if circleView.isHidden {
            circleView.isHidden = false
            self.infoImageView.isHidden = true
            infoLabel.isHidden = true
            
        }else{
            circleView.isHidden = true
            self.infoImageView.isHidden = false
            infoLabel.isHidden = false
        }
        print("toggle Button Pressed")
        
    }
    //MARK: UIComponents
    func setUpUIComponents() {
    
        
        infoImageView.isHidden = true
        infoLabel.isHidden = true
        
        itemTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        itemTableView.bounces = false
        
        let radius = min(circleView.bounds.width, circleView.bounds.height) / 2
        circleView.layer.cornerRadius = radius
        circleView.clipsToBounds = true
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGesture.direction = .left
        circleView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGesture.direction = .right
        circleView.addGestureRecognizer(rightSwipeGesture)
        
        
    }
    
    func loadMoreData() {
        
        let newData = Food.defaultFoodList()
        
        // Append new data to the existing array
        foodListArray.append(contentsOf: newData)
        itemTableView.reloadData()
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed else {
            return
        }
        self.infoImageView.isHidden = true
        infoLabel.isHidden = true
        if circleView.isHidden {
            circleView.isHidden = false
        } else {
            circleView.isHidden = true
            self.infoImageView.isHidden = false
            infoLabel.isHidden = false

        }
    }
    
    
    @objc func handleLeftSwipe(_ gesture: UISwipeGestureRecognizer) {
        
        
        
        if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5) {
                
                var frame = self.circleView.frame
                frame.origin.x -= 230
                self.circleView.frame = frame
                self.count = 0
            }
            print("Left swipe detected")
        }
    }
    
    
    @objc func handleRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        
        if count == 0 {
            if gesture.state == .ended {
                UIView.animate(withDuration: 0.5) { [self] in
                    
                    var frame = self.circleView.frame
                    frame.origin.x += 230
                    self.circleView.frame = frame
                    self.count += 1
                }
            }
        }
    }
    
    
    func animateImageSize(xFront: CGFloat, yFront: CGFloat, label: UILabel){
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            label.transform = CGAffineTransform(scaleX: xFront, y: yFront)
        }, completion: nil)
    }
    
}

//MARK: Extension
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //     print("foodListArray", foodListArray.count)
        return foodListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
        cell.itemLbl.layer.cornerRadius = 26
        cell.itemLbl.clipsToBounds = true
        cell.selectionStyle = .none
       
        cell.itemLbl.text = "\(foodListArray[indexPath.row].foodName)"
        
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.itemLbl.textColor = UIColor.red
        } else {
            cell.itemLbl.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
            return
        }
        
        cell.itemLbl.textColor = UIColor.red
        
        if let prevSelectedIndexPath = selectedIndexPath {
            tableView.deselectRow(at: prevSelectedIndexPath, animated: true)
            if let prevSelectedCell = itemTableView.cellForRow(at: prevSelectedIndexPath) as? ItemTableViewCell {
                prevSelectedCell.itemLbl.textColor = UIColor.black
            }
        }
        selectedIndexPath = indexPath
        currentIndex = indexPath.row
        UIView.animate(withDuration: 0.3, animations: {
                self.infoImageView.alpha = 0
            }) { _ in
               
                self.infoImageView.image = UIImage(named: "\(imageArray[currentIndex])")
                
                // Fade in the new image
                UIView.animate(withDuration: 0.3) {
                    self.infoImageView.alpha = 1
                }
            }
//        infoImageView.image = UIImage(named: "\(imageArray[currentIndex])")
        infoLabel.text = "The above picture is \(imageArray[currentIndex])"
        infoLabel.textColor = UIColor.black
        circleView.isHidden = true
        infoImageView.isHidden = false
        infoLabel.isHidden = false
        itemTableView.deselectRow(at: indexPath, animated: true)
       // performSegue(withIdentifier: "image", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == foodListArray.count - 1 {
            loadMoreData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y

        // Hide or show the navigation bar based on the scroll direction
        if offsetY > 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        
        DispatchQueue.main.async {
            let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
            let middleIndex = visibleIndexPaths.count / 2
            let visibleCellCount = visibleIndexPaths.count
            let initialCellWidth: CGFloat = 250.0
            let decrementGap: CGFloat = 45
            
            
            for (index, indexPath) in visibleIndexPaths.enumerated() {
                guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
                    continue
                }
                
                let distanceFromMiddle = index - middleIndex
                let decrement = CGFloat(abs(distanceFromMiddle)) * decrementGap
                
                if distanceFromMiddle == 0 {
                    // Middle row
                    cell.viewWidthConstraint.constant = initialCellWidth
                } else if distanceFromMiddle < 0 {
                    // Rows above the middle row
                    let newWidth = initialCellWidth - CGFloat(abs(distanceFromMiddle)) * decrementGap
                    cell.viewWidthConstraint.constant = max(newWidth, 0)
                } else {
                    // Rows below the middle row
                    cell.viewWidthConstraint.constant = initialCellWidth - decrement
                }
                
                cell.layoutIfNeeded()
              
                
            }
            
        }
    }
        
    }
    








