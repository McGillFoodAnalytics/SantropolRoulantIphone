//
//  BottomSheetViewController.swift
//  NestedScrollView
//
//  Created by ugur on 12.08.2018.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

enum SheetLevel{
    case top, bottom, middle
}

protocol BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect)
}

class BottomSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet var panView: UIView!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var collectionView: UICollectionView! //header view
    
    var lastY: CGFloat = 0
    var pan: UIPanGestureRecognizer!
    
    var bottomSheetDelegate: BottomSheetDelegate?
    var parentView: UIView!
    
    var initalFrame: CGRect!
    var topY: CGFloat = 80 //change this in viewWillAppear for top position
    var middleY: CGFloat = 300 //change this in viewWillAppear to decide if animate to top or bottom
    var bottomY: CGFloat = 600 //no need to change this
    let bottomOffset: CGFloat = 127 //sheet height on bottom position
    var lastLevel: SheetLevel = .middle //choose inital position of the sheet
    
    var disableTableScroll = false
    
    //hack panOffset To prevent jump when goes from top to down
    var panOffset: CGFloat = 0
    var applyPanOffset = false
    
    //tableview variables
    var listItems: [Any] = []
    var headerItems: [Any] = []
    var test: String = "bonjour"

    var containerViewController: BottomSheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.panView.addGestureRecognizer(pan)

        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        
        //Bug fix #5. see https://github.com/OfTheWolf/UBottomSheet/issues/5
        //Tableview didselect works on second try sometimes so i use here a tap gesture recognizer instead of didselect method and find the table row tapped in the handleTap(_:) method
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        //Bug fix #5 end
        containerViewController?.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        if test == "Date:27/7/2019" {
            
            test = "this works"
        }
        
       tableView.reloadData()
        
        super.viewWillAppear(animated)
        self.initalFrame = UIScreen.main.bounds
        self.topY = round(initalFrame.height * 0.10)
        self.middleY = initalFrame.height * 0.6
        self.bottomY = initalFrame.height - bottomOffset
        self.lastY = self.middleY
        
        bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.middleY))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {return}

        if (self.parentView.frame.minY > topY){
            self.tableView.contentOffset.y = 0
        }
    }


    //this stops unintended tableview scrolling while animating to top
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == tableView else {return}

        if disableTableScroll{
            targetContentOffset.pointee = scrollView.contentOffset
            disableTableScroll = false
        }
    }
    
    //Bug fix #5. see https://github.com/OfTheWolf/UBottomSheet/issues/5
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        let p = recognizer.location(in: self.tableView)
        let index = tableView.indexPathForRow(at: p)
        //WARNING: calling selectRow doesn't trigger tableView didselect delegate. So handle selected row here.
        //You can remove this line if you dont want to force select the cell
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
    }//Bug fix #5 end
    
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){

        let dy = recognizer.translation(in: self.parentView).y
        switch recognizer.state {
        case .began:
            applyPanOffset = (self.tableView.contentOffset.y > 0)
        case .changed:
            if self.tableView.contentOffset.y > 0{
                panOffset = dy
                return
            }
            
            if self.tableView.contentOffset.y <= 0{
                if !applyPanOffset{panOffset = 0}
                let maxY = max(topY, lastY + dy - panOffset)
                let y = min(bottomY, maxY)
                //                self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: y)
                bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
            }
            
            if self.parentView.frame.minY > topY{
                self.tableView.contentOffset.y = 0
            }
        case .failed, .ended, .cancelled:
            panOffset = 0
            
            //bug fix #6. see https://github.com/OfTheWolf/UBottomSheet/issues/6
            if (self.tableView.contentOffset.y > 0){
                return
            }//bug fix #6 end
            
            self.panView.isUserInteractionEnabled = false
            
            self.disableTableScroll = self.lastLevel != .top
            
            self.lastY = self.parentView.frame.minY
            self.lastLevel = self.nextLevel(recognizer: recognizer)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
                
                switch self.lastLevel{
                case .top:
                    //                    self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: self.topY)
                    self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.topY))
                    self.tableView.contentInset.bottom = 50
                case .middle:
                    //                    self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: self.middleY)
                    self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.middleY))
                case .bottom:
                    //                    self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: self.bottomY)
                    self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.bottomY))
                }
                
            }) { (_) in
                self.panView.isUserInteractionEnabled = true
                self.lastY = self.parentView.frame.minY
            }
        default:
            break
        }
    }
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> SheetLevel{
      let y = self.lastY
        let velY = recognizer.velocity(in: self.view).y
        if velY < -200{
            return y > middleY ? .middle : .top
        }else if velY > 200{
            return y < (middleY + 1) ? .middle : .bottom
        }else{
            if y > middleY {
                return (y - middleY) < (bottomY - y) ? .middle : .bottom
            }else{
                return (y - topY) < (middleY - y) ? .top : .middle
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
        let model = SimpleTableCellViewModel(image: nil, title: "\(test) \(indexPath.row)", subtitle: "Subtitle \(indexPath.row)")
        cell.configure(model: model)
        return cell
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}


