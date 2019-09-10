//
//  BottomSheetViewController.swift
//  NestedScrollView
//
//  Created by ugur on 12.08.2018.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


enum SheetLevel{
    case top, bottom, middle
}

protocol BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect)
}

class BottomSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var panView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var notice: UILabel!
    @IBOutlet weak var currentVolunteersLbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var slotLbl: UILabel!//    @IBOutlet weak var collectionView: UICollectionView! //header view
    @IBOutlet weak var numberSpotsLbl: UILabel!
    @IBOutlet weak var spotsAvailableLbl: UILabel!
    
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
    var test: String = "5"
    var typecontroller: String!
    
    // Variables for the Firebase Query
    var namesRegistered = [Names]()
    var userInformation = [UserInformation]()
    var location_start_query: String = ""
    var location_end_query: String = ""
    var eventint: Int! = 190801
    var isADriver: Bool = false
    var verificationArray = [Int]()
    var slotNumberSelected: Int = 0
    
    let userid = Auth.auth().currentUser!.uid
    
    
    var containerViewController: BottomSheetViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goConfirmationPage" {
            let destinationVC = segue.destination as? ConfirmationPage
            
            destinationVC?.namesRegistered = self.namesRegistered
            
            
            
            destinationVC?.typecontroller = self.typecontroller
            
            
            
            destinationVC?.eventDate = self.dateLabel.text
            destinationVC?.eventType = self.namesRegistered[0].event_type_user
            destinationVC?.eventSlot = self.slotLbl.text
            destinationVC?.eventint = eventint
            destinationVC?.slotNumberSelected = self.slotNumberSelected
            
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.panView.addGestureRecognizer(pan)
        
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        
        //Bug fix #5. see https://github.com/OfTheWolf/UBottomSheet/issues/5
        //Tableview didselect works on second try sometimes so i use here a tap gesture recognizer instead of didselect method and find the table row tapped in the handleTap(_:) method
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let gestures = tableView.gestureRecognizers {
            for gesture in gestures {
                if let recognizer = gesture as? UITapGestureRecognizer {
                    tableView.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        /*   pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
         pan.delegate = self
         self.panView.addGestureRecognizer(pan)
         
         self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
         
         //Bug fix #5. see https://github.com/OfTheWolf/UBottomSheet/issues/5
         //Tableview didselect works on second try sometimes so i use here a tap gesture recognizer instead of didselect method and find the table row tapped in the handleTap(_:) method
         let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
         tap.delegate = self
         tableView.addGestureRecognizer(tap) */
        //Bug fix #5 end
        //   containerViewController?.viewDidLoad()
        
        
        
    } // Ends viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        
        
        // Determine the scope of the Firebase query
        if typecontroller == "Meal Delivery Driver" || typecontroller == "Meal Delivery Non-Driver"  {
            
            location_start_query = "deldr"
            location_end_query = "deliv"
            
            
        } else if typecontroller == "Kitchen AM" {
            
            location_start_query = "kitam"
            location_end_query = "kitas"
            
        } else {
            
            location_start_query = "kitpm"
            location_end_query = "kitps"
            
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Need to first check if the date exists
        
        Database.database().reference().child("event").queryOrdered(byChild: "event_type").queryStarting(atValue: location_start_query).queryEnding(atValue: location_end_query).observe(.value, with: { (snapshot) in
            
            for child in snapshot.children {
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                let event_int_dummy = dict?["event_date"] as? Int ?? 0
                
                self.verificationArray.append(event_int_dummy)
                
                // Remove duplicates (optional step)
                self.verificationArray = self.verificationArray.unique()
            }
            
            if self.verificationArray.contains(self.eventint) {
                
                self.tableView.isHidden = false
                self.currentVolunteersLbl.text = "Current Volunteers:"
                self.spotsAvailableLbl.text = "spots available"
                self.notice.isHidden = true
                
                
                // Date is contained in the database and therefore, we must display the users registered to it
                
                // Continue the steps as usual
                
                
                Database.database().reference().child("event").queryOrderedByKey().queryStarting(atValue: String(self.eventint) + self.location_start_query + "01").queryEnding(atValue: String(self.eventint) + self.location_end_query + "99").observe(.value, with: { (snapshot) in
                    
                    self.namesRegistered.removeAll()
                    
                    //   queryOrdered(byChild: "event_date").queryEqual(toValue: self.eventint)
                    
                    for child in snapshot.children {
                        
                        let childSnapshot = child as? DataSnapshot
                        let dict = childSnapshot?.value as? [String:Any]
                        
                        let event_type = dict?["event_type"] as! String
                        
                        // Now determine from the event type if the user is a driver or not
                        
                        var driver_dummy = event_type.prefix(4).suffix(1)
                        
                        
                        if driver_dummy == "d" {
                            
                            self.isADriver = true
                            
                        } else {
                            
                            self.isADriver = false
                            
                        }
                        
                        
                        // Do a query to get the first and last names of the registered users
                        
                        
                        // let uid = dict?["uid"] as? [String:Any]
                        
                        let first_name = dict?["first_name"] as? String
                        let last_name = dict?["last_name"] as? String
                        
                        let user_id = dict?["key"] as? String
                        
                        let driver = self.isADriver
                        
                        let event_start = dict?["event_time_start"] as? String
                        let event_end = dict?["event_time_end"] as? String
                        let note = dict?["note"] as? String
                        let eventint = dict?["event_date"] as? Int
                        
                        
                        let nameAttendee = Names(firstName: first_name, lastName: last_name, uid: user_id, driver: driver, event_type_user: event_type, event_start: event_start, event_end: event_end, note: note)
                        
                        // Create array here
                        
                        
                        
                        self.namesRegistered.append(nameAttendee)
                        
                        
                        //    self.namesRegistered.sort {$0.driver ?? false && !$1.driver!}
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        self.tableView.reloadData()
                        
                    }
                    
                    let number_user_array = self.namesRegistered.map {$0.uid}
                    
                    let count_nonNils = number_user_array.filter({$0 != "nan"}).count
                    
                    let available_space = number_user_array.count - count_nonNils
                    
                    self.numberSpotsLbl.text = "\(available_space)"
                    
                    // Need to first check if the date exists
                    self.slotLbl.text = "\(self.namesRegistered[0].event_start ?? "")-\(self.namesRegistered[0].event_end ?? "")"
                    
                })
                
                
                
            } else {
                
                
                // Date is NOT contained in the database, hide the tableView and display the message that there is no event for the given date
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.isHidden = true
                
                self.numberSpotsLbl.text = ""
                
                self.slotLbl.text = ""
                self.spotsAvailableLbl.text = ""
                self.currentVolunteersLbl.text = ""
                self.notice.isHidden = false
                
                
            }
            
        })
        
        
        
        
        
        
        
        
        self.initalFrame = UIScreen.main.bounds
        self.topY = round(initalFrame.height * 0.10)
        self.middleY = initalFrame.height * 0.6
        self.bottomY = initalFrame.height - bottomOffset
        self.lastY = self.middleY
        
        bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.middleY))
        
        
        tableView.dataSource = self
        tableView.delegate = self
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
        
        guard let number = index?.row else {
            return
        }
        
        
        let namesRegisteredArray = namesRegistered.map {$0.uid}
        
        // The following block of code prevents a user from registering twice to the same event (disabled for now for development purposes)
        
             if namesRegisteredArray.contains(userid) {
         
         // Create an alert blocking the user to register for this event
         let alert = UIAlertController(title: "Error", message: "You are already registered to this activity!", preferredStyle: .alert)
         
         let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         
         alert.addAction(OKAction)
         
         self.present(alert, animated: true, completion: nil)
         
         return
         
         
         }
        
        if number + 1 > namesRegistered.count {
            
            return
        }
        
        if typecontroller == "Meal Delivery Non-Driver"{
            
            self.slotNumberSelected = number - 1
            
        } else {
            
            self.slotNumberSelected = number + 1
            
        }
        
        
        if typecontroller == "Meal Delivery Driver" && self.slotNumberSelected > 2 {
            
            // do nothing, user selected a non-driver spot
        } else if typecontroller == "Meal Delivery Non-Driver" && self.slotNumberSelected < 1 {
            
            // do nothing, user selected a driver spot
        } else if (namesRegistered[number].uid ?? "" == "nan") && number < namesRegistered.count + 1  {
            
            performSegue(withIdentifier: "goConfirmationPage", sender: self)
            tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            
            
        } else {
            
            // do nothing
        }
        
        
        print(number + 1)
        
        
        //WARNING: calling selectRow doesn't trigger tableView didselect delegate. So handle selected row here.
        //You can remove this line if you dont want to force select the cell
        
        
        //   performSegue(withIdentifier: "goConfirmationPage", sender: self)
        
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
        return namesRegistered.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
        
        var image:UIImage? = nil
        
        var namesRegistered2 = namesRegistered
        
        let userdummy1 = Names(firstName: "", lastName: "", uid: "", driver: false, event_type_user: "", event_start: "", event_end: "", note: "")
        let userdummy2 = Names(firstName: "", lastName: "", uid: "", driver: false, event_type_user: "", event_start: "", event_end: "", note: "")
        
        namesRegistered2.append(userdummy1)
        namesRegistered2.append(userdummy2)
        
        
        let details: Names
        
        details = namesRegistered2[indexPath.row]
        
        
        
        
        if indexPath.row < 2 && (typecontroller == "Meal Delivery Driver" || typecontroller == "Meal Delivery Non-Driver") {
            image = UIImage(named: "suv")
            
            
        }
        
        
        if (typecontroller == "Meal Delivery Driver" && indexPath.row > 1) || (typecontroller == "Meal Delivery Non-Driver" && indexPath.row < 2)  {
            
            
            cell.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
            
            if indexPath.row > namesRegistered.count - 1 {
                
                cell._titleLabel.textColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
                
            } else {
                
                cell._titleLabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
                
                
            }
            
        } else {
            
            cell.backgroundColor = UIColor.white
            
            if indexPath.row > namesRegistered.count - 1 {
                
                cell._titleLabel.textColor = UIColor.white
                
            } else {
                
                cell._titleLabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
                
                
            }
        }
        
        
        // Show the notes if
        if indexPath.row < 2 && (typecontroller == "Meal Delivery Driver" || typecontroller == "Meal Delivery Non-Driver") && details.note != "" {
            
            let model = SimpleTableCellViewModel(image: image, title: "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName?.prefix(1) ?? ""). (\(details.note ?? ""))", subtitle: "Subtitle \(indexPath.row)")
            cell.configure(model: model)
            
        } else  {
            
            let model = SimpleTableCellViewModel(image: image, title: "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName?.prefix(1) ?? "").", subtitle: "Subtitle \(indexPath.row)")
            cell.configure(model: model)
            
            
        }
        
        
        
        
        
        return cell
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}


