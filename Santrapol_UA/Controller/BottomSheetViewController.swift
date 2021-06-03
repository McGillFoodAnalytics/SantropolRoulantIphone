//
//  BottomSheetViewController.swift
//  NestedScrollView
//
//  Created by ugur on 12.08.2018.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import UBottomSheet
import FirebaseDatabase
import FirebaseAuth


class BottomSheetViewController: BottomSheetController, UITableViewDelegate, UITableViewDataSource {
    
      //  MARK: BottomSheetController configurations
 
        
    //    //Override this to apply custom animations
    //    override func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
    //        UIView.animate(withDuration: 0.3, animations: animations)
    //    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var notice: UILabel!
    @IBOutlet weak var currentVolunteersLbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var slotLbl: UILabel!//    @IBOutlet weak var collectionView: UICollectionView! //header view
    @IBOutlet weak var numberSpotsLbl: UILabel!
    @IBOutlet weak var spotsAvailableLbl: UILabel!
    

    //tableview variables
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

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
        if typecontroller == "Meal Delivery Driver" {
            location_start_query = "deldr"
            location_end_query = "deldr"
        } else if typecontroller == "Meal Delivery Non-Driver" {
            location_start_query = "deliv"
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
                
                if Locale.current.languageCode == "fr"{
                    self.currentVolunteersLbl.text = "Bénévoles actuels:"
                    self.spotsAvailableLbl.text = "places dispos"
                }
                else{
                    self.currentVolunteersLbl.text = "Current Volunteers:"
                    self.spotsAvailableLbl.text = "spots available"
                }
                
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
                        
                        let driver_dummy = event_type.prefix(4).suffix(1)
                        
                        
                        if driver_dummy == "d" {
                            
                            self.isADriver = true
                            
                        } else {
                            
                            self.isADriver = false
                            
                        }
                        
                        
                        // Do a query to get the first and last names of the registered users
                        
                        
                        // let uid = dict?["uid"] as? [String:Any]
                        
                        let first_name = dict?["first_name"] as? String
                        let last_name = dict?["last_name"] as? String
                        
                        let user_key = dict?["key"] as? String
                        let user_id = dict?["uid"] as? String
                        
                        let driver = self.isADriver
                        
                        let event_start = dict?["event_time_start"] as? String
                        let event_end = dict?["event_time_end"] as? String
                        // let note = dict?["note"] as? String
                        let _ = dict?["event_date"] as? Int
                        
                        
                        let nameAttendee = Names(firstName: first_name, lastName: last_name, key: user_key, uid: user_id, driver: driver, event_type_user: event_type, event_start: event_start, event_end: event_end)
                        
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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesRegistered.count + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
        
        var image:UIImage? = nil
        
        var namesRegisteredDummy = namesRegistered
        
        let userdummy1 = Names(firstName: "", lastName: "", key: "", uid: "", driver: false, event_type_user: "", event_start: "", event_end: "")
        let userdummy2 = Names(firstName: "", lastName: "", key: "", uid: "", driver: false, event_type_user: "", event_start: "", event_end: "")
        
        namesRegisteredDummy.append(userdummy1)
        namesRegisteredDummy.append(userdummy2)
        
        let details: Names
        
        
        details = namesRegisteredDummy[indexPath.row]
        
        
        if indexPath.row < 4 && typecontroller == "Meal Delivery Driver" {
            image = UIImage(named: "suv")
        }
        /*
        if (typecontroller == "Meal Delivery Driver" && indexPath.row > 1) || (typecontroller == "Meal Delivery Non-Driver" && indexPath.row < 2)  {
            
            
            cell.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
            
            if indexPath.row > namesRegistered.count - 1 {
                
                cell._titleLabel.textColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
                
            } else {
                
                cell._titleLabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
                
                
            }
            
        } else {
        */
            cell.backgroundColor = UIColor.white
            
            if indexPath.row > namesRegistered.count - 1 {
                
                cell._titleLabel.textColor = UIColor.white
                
            } else {
                
                cell._titleLabel.textColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
                
                
            }
       // }
        
        
        // Show the notes if
        /*
        if indexPath.row < 3 && (typecontroller == "Meal Delivery Driver" || typecontroller == "Meal Delivery Non-Driver") && details.note != "" {
            
            if details.lastName == "" {
                
                let model = SimpleTableCellViewModel(image: image, title: "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName?.prefix(1) ?? "") (\(details.note ?? ""))", subtitle: "Subtitle \(indexPath.row)")
                cell.configure(model: model)
                
                
            } else {
                
                
                let model = SimpleTableCellViewModel(image: image, title: "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName?.prefix(1) ?? ""). (\(details.note ?? ""))", subtitle: "Subtitle \(indexPath.row)")
                cell.configure(model: model)
                
                
            }

        
        } else  {
         */
            if details.lastName == "" {
                
                let model = SimpleTableCellViewModel(image: image, title: "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName?.prefix(1) ?? "")", subtitle: "Subtitle \(indexPath.row)")
                cell.configure(model: model)
                
                
            } else {
                
                let model = SimpleTableCellViewModel(image: image, title: "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName?.prefix(1) ?? "").", subtitle: "Subtitle \(indexPath.row)")
                cell.configure(model: model)
            }
            
        //}
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        let number = indexPath.row
        
        
        let namesRegisteredArrayUid = namesRegistered.map {$0.uid}
        let namesRegisteredArrayKey = namesRegistered.map {$0.key}

        
        // The following block of code prevents a user from registering twice to the same event (disabled for now for development purposes)
        
        if namesRegisteredArrayUid .contains(userid)  {
         
        // Create an alert blocking the user to register for this event
        
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert);
            
            if Locale.current.languageCode == "fr"{
                alert = UIAlertController(title: "Avez-vous un jumeau?", message: "... parce que vous êtes déjà inscrit à cette activité!", preferredStyle: .alert)
            }
            else{
                alert = UIAlertController(title: "Do you have a twin?", message: "... because you have already registered for this activity!", preferredStyle: .alert)
            }
         
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         
            alert.addAction(OKAction)
         
            self.present(alert, animated: true, completion: nil)
         
            return
         }
        
        
        if number + 1 > namesRegistered.count {
            
            return
        }
        
       /*
        if typecontroller == "Meal Delivery Non-Driver"{
            
            self.slotNumberSelected = number - 1
            
        } else {
            
            self.slotNumberSelected = number + 1
            
        }
        */
        self.slotNumberSelected = number + 1
        /*
        if typecontroller == "Meal Delivery Driver" && self.slotNumberSelected > 2 {
            
            // do nothing, user selected a non-driver spot
        } else if typecontroller == "Meal Delivery Non-Driver" && self.slotNumberSelected < 1 {
        
            // do nothing, user selected a driver spot
        
        
        }
         */
        if (namesRegistered[number].uid ?? "" == "nan") && number < namesRegistered.count + 1  {
            
            performSegue(withIdentifier: "goConfirmationPage", sender: self)
            
        } else {
            
            // do nothing
        }
        
        
        print(number + 1)
        
        
        //WARNING: calling selectRow doesn't trigger tableView didselect delegate. So handle selected row here.
        //You can remove this line if you dont want to force select the cell
        
        
        //   performSegue(withIdentifier: "goConfirmationPage", sender: self)
    }
    
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}


