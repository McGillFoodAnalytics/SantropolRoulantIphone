//
//  ListVolunteer.swift
//  Santrapol_UA
//
//  Created by G Lapierre on 2019-06-30.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ListVolunteer: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listName: UITableView!
    @IBOutlet weak var PageHeader: UINavigationItem!
    @IBOutlet weak var AdditionalNote: UITextField!
    @IBOutlet weak var driverSwitch: UISwitch!
    @IBOutlet weak var driverlabel: UILabel!
    
    
    var namesRegistered = [Names]()
    var userInformation = [UserInformation]()
    
    
    var ref:DatabaseReference?
    var location: String!
    var dummy: String!
    var cap: Int!
    var driverCap: Int!
    var typecontroller: String!
    var isOn: Bool = false
    var driverIsOn: Bool = false
    let userid = Auth.auth().currentUser!.uid
    var countDriver: Int!
    
    var eventint: Int!
    var eventtype: String!
    var location_start_query: String = ""
    var location_end_query: String = ""
    var isADriver: Bool = false
    
    
    
    // Number of rows that will show up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesRegistered.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! CellNames
        
        let details: Names
        
        details = namesRegistered[indexPath.row]
        
        
        if details.driver == true {
            
            cell.Name.text = "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName ?? "") (driver)" // details. something
            
        } else {
            
            cell.Name.text = "\(indexPath.row + 1). \(details.firstName ?? "") \(details.lastName ?? "")"  // details. something
            
        }
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToListVolunteers") {
            let vc = segue.destination as! ListVolunteer

            vc.eventtype = eventtype
            vc.dummy = dummy
            vc.typecontroller = location
        }
    }

    
    @objc func didTapEditButton(sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : HomePage = storyboard.instantiateViewController(withIdentifier: "HomePage") as! HomePage
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "Confirmation"
        
        var image = UIImage(named: "Screen Shot 2019-01-27 at 1.05.03 PM")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        
        if typecontroller != "Meal Delivery" {
            
            driverSwitch.isHidden = true
            driverlabel.isHidden = true
        
        }
        
        AdditionalNote.delegate = self
        
     //   listName.delegate = self
      //  listName.dataSource = self

        // Create the namesRegistered Array here
        
        if typecontroller == "Meal Delivery" {
            
            location_start_query = "deldr"
            location_end_query = "deliv"
            
            
        } else if typecontroller == "Kitchen AM" {
            
            location_start_query = "kitam"
            location_end_query = "kitas"
            
        } else {
            
            location_start_query = "kitpm"
            location_end_query = "kitps"
            
        }
        
        // Do a query to get the type of event (this will allow to define if the given user is a driver or not)
        
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

                
                
                let nameAttendee = Names(firstName: first_name, lastName: last_name, uid: user_id, driver: driver, event_type_user: event_type)
                
                // Create array here
                
                self.namesRegistered.append(nameAttendee)
            //    self.namesRegistered.sort {$0.driver ?? false && !$1.driver!}
                
                self.listName.reloadData()

                
            
                
            }
            
        })
        
        
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        
        DisplayVC.location = typecontroller
        DisplayVC.dummy = dummy
        
        self.present(DisplayVC, animated: false, completion: nil)
        
        
    }
    
    @IBAction func newSwitch(_ sender: UISwitch) {
        
        if (sender.isOn == true){
            
            isOn = true
            
        } else {
            
            isOn = false
        }
        
    }
    
    @IBAction func driverSwitch(_ sender: UISwitch) {
        
        
        if (sender.isOn == true){
            
            driverIsOn = true
            
        } else {
            
            driverIsOn = false
        }
        
    }
    
    
    @IBAction func SubmitTapped(_ sender: UIButton) {
        
        var event_type_register: String = ""
        var user_first_name: String?
        var user_last_name: String?
        var user_key: String?
        var user_uid: String?
        
        
        if typecontroller == "Meal Delivery" {
            

            
            // Account for if the event takes place on a Saturday (check if the suffix of event_type is a "s")
            
            if eventtype.suffix(1) == "s" {
                
                // If it is a Saturday
                
                if driverIsOn == true {
                    
                    // Driver is on AND it is Saturday
                    event_type_register = "delds"
                    
                    
                    
                } else {
                    
                    // Driver is off AND it is Saturday
                    event_type_register = "delis"
                    
                    
                }
                
                
                
            } else {
                
                // It is not Saturday
                
                if driverIsOn == true {
                    
                    event_type_register = "deldr"
                    
                    
                } else {
                    
                    // Driver is off (not Saturday)
                    
                    event_type_register = "deliv"
                    
                    
                }
                
            }
            
            
                // In the namesRegistered array, need to filter out all entries corresponding to the event_type_register
            
           let interest = namesRegistered.filter({$0.event_type_user == event_type_register})
           
            let event_type_array = interest.map {$0.uid} // Creates a new array containing only the uid of the users registered for the chosen event type based on the user selection
            
            
        // Lookup for the first index which corresponds to an empty string in the names position
            
            guard let firstIndexNil = event_type_array.firstIndex(of: "nan")
            
                else {
                    
                    // Returns an alert if the first index of the chosen string does not exist
                    
                    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    
                    if Locale.current.languageCode == "fr"{
                        alert = UIAlertController(title: "Note", message: "Space unavailable for your given choice!", preferredStyle: .alert)
                    }
                    else{
                        alert = UIAlertController(title: "Note", message: "Il n'y a pas d'espace disponible pour ce choix", preferredStyle: .alert)
                    }
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
            }
                
            // Write data in the corresponding slot

            // Data to write: First name, last name, key (internal user id from Firebase)
            

            
            // Do a query from the internal user id to write the information about registered users to the firebase
            
            
            
            Database.database().reference().child("user").queryOrdered(byChild: "key").queryEqual(toValue: userid).observe(.value, with: { (snapshot) in
                
                for child in snapshot.children {
                    
                    let childSnapshot = child as? DataSnapshot
                    let dict = childSnapshot?.value as? [String:Any]
                    
                
                    // Fetch the user information and communicate to the global variable
                    
                    user_uid = childSnapshot?.key
                    user_first_name = dict?["first_name"] as? String
                    user_last_name = dict?["last_name"] as? String
                    user_key = dict?["key"] as? String
                    
                    
                    
              /*      Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("uid").setValue(dictionary) */
                    
                    // User key
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("key").setValue(user_key)
                    
                    // User ID
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("uid").setValue(user_uid)
                    
                    
                    // User First Name
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("first_name").setValue(user_first_name)
                    
                    // User Last Name
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("last_name").setValue(user_last_name)
                    
                    
                    // Adds additional notes to the Firebase database
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("note").setValue(self.AdditionalNote.text)
                    
                    // Is the user new?
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("first_shift").setValue(self.isOn)
                    
                }
                
            })
            
            
            let viewControllers = self.navigationController!.viewControllers
            for var aViewController in viewControllers
            {
                if aViewController is ViewController
                {
                    let aVC = aViewController as! ViewController
                    aVC.location = typecontroller
                    aVC.dummy = dummy
                    aVC.registered = "yes"
                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                }
            } // End of the loop
            
            
            
        } else {
            
            
            
            if eventtype.suffix(1) == "s" {
                
                // If it is a Saturday
                
                 if typecontroller == "Kitchen AM" {
                    
                    // Driver is on AND it is Saturday
                    event_type_register = "kitas"
                    
                    
                    
                } else {
                    
                    // Driver is off AND it is Saturday
                    event_type_register = "kitps"
                    
                    
                }
                
                
                
            } else {
                
                // It is not Saturday
                
                if typecontroller == "Kitchen AM" {
                    
                    event_type_register = "kitam"
                    
                    
                } else {
                    
                    // Driver is off (not Saturday)
                    
                    event_type_register = "kitpm"
                    
                    
                }
                
            }
            
            
            
            // In the namesRegistered array, need to filter out all entries corresponding to the event_type_register
            
            let interest = namesRegistered.filter({$0.event_type_user == event_type_register})
            
            let event_type_array = interest.map {$0.uid} // Creates a new array containing only the uid of the users registered for the chosen event type based on the user selection
            
            
            // Lookup for the first index which corresponds to an empty string in the names position
            
            guard let firstIndexNil = event_type_array.firstIndex(of: "nan")
                
                else {
                    
                    // Returns an alert if the first index of the chosen string does not exist
                    
                    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    
                    if Locale.current.languageCode == "fr"{
                        alert = UIAlertController(title: "Note", message: "Space unavailable for your given choice!", preferredStyle: .alert)
                    }
                    else{
                        alert = UIAlertController(title: "Note", message: "Il n'y a pas d'espace disponible pour ce choix", preferredStyle: .alert)
                    }
                    
                    
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
            }
            
            // Write data in the corresponding slot
            
            // Data to write: First name, last name, key (internal user id from Firebase)
            
            
            
            // Do a query from the internal user id to write the information about registered users to the firebase
            
            
            Database.database().reference().child("user").queryOrdered(byChild: "key").queryEqual(toValue: userid).observe(.value, with: { (snapshot) in
                
                for child in snapshot.children {
                    
                    let childSnapshot = child as? DataSnapshot
                    let dict = childSnapshot?.value as? [String:Any]
                    
                    
                    // Fetch the user information and communicate to the global variable
                    
                    user_uid = childSnapshot?.key
                    user_first_name = dict?["first_name"] as? String
                    user_last_name = dict?["last_name"] as? String
                    user_key = dict?["key"] as? String
                    
                    
                    
                    // Call the information to transfer in the database
                    
                    let dictionary: NSDictionary = [
                        "first_name" : user_first_name,
                        "last_name" : user_last_name,
                        "key": user_key,
                        "uid": user_uid
                        
                        // Write more information about the user in the future
                        
                    ]
                    
                    // User key
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("key").setValue(user_key)
                    
                    // User ID
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("uid").setValue(user_uid)
                    
                    
                    // User First Name
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("first_name").setValue(user_first_name)
                    
                    // User Last Name
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("last_name").setValue(user_last_name)
                    
                    
                    // Adds additional notes to the Firebase database
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("note").setValue(self.AdditionalNote.text)
                    
                    // Is the user new?
                    Database.database().reference().child("event").child(String(self.eventint) + event_type_register + "0" + String(firstIndexNil + 1)).child("first_shift").setValue(self.isOn)

                    
                }
                
            })
            
           /* let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
            
            DisplayVC.location = typecontroller
            DisplayVC.dummy = dummy
            DisplayVC.registered = "yes"
            
            self.present(DisplayVC, animated: true, completion: nil) */
            
            
            let viewControllers = self.navigationController!.viewControllers
            for var aViewController in viewControllers
            {
                if aViewController is ViewController
                {
                    let aVC = aViewController as! ViewController
                    aVC.location = typecontroller
                    aVC.dummy = dummy
                    aVC.registered = "yes"
                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                }
            } // End of the loop
            
            
            
        }
        
    }
    

} // end of the class


extension ListVolunteer: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
