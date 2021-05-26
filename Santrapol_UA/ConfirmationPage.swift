//
//  ConfirmationPage.swift
//  Santrapol_UA
//
//  Created by G Lapierre on 2019-07-30.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ConfirmationPage: UIViewController {
    
    //TEST
    
    // Test #2

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var remarksView: UIView!
    
    
    @IBOutlet weak var imageType: UIImageView!
    
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTypeLbl: UILabel!
    @IBOutlet weak var eventSlotLbl: UILabel!
    
    
    
    @IBOutlet weak var driverLbl1: UILabel!
    @IBOutlet weak var driverLbl2: UILabel!
    
    @IBOutlet weak var additionalNotes: UITextView!
    
    @IBOutlet weak var switchNew: UISwitch!
    @IBOutlet weak var switchDriver: UISwitch!
    
    var eventDate: String!
    var eventType: String!
    var eventSlot: String!
    var eventint: Int!
    var typecontroller: String!
    var slotNumberSelected: Int!
    
    
    var user_key_global: String?
    var user_uid_global: String?
    var user_first_name_global: String?
    var user_last_name_global: String?
  //  var location_start_query: String = "" // Might delete after
  //  var location_end_query: String = "" // Might delete after
    
    // Switch
    var isOn: Bool = false
    var driverIsOn: Bool = false
    
    var namesRegistered = [Names]()
    let userid = Auth.auth().currentUser!.uid
    var userInformation = [UserInformation]()
    
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
        print(typecontroller)
        
        var user_first_name: String?
        var user_last_name: String?
        var user_key: String?
        var user_uid: String?
        
        additionalNotes.frame =  CGRect(x: 30, y: 0, width: (UIScreen.main.bounds.width - 27 - 20 - 10 - 10), height: 30)
        
        // additionalNotes.setBottomBorder(withColor: UIColor.white)
        
        self.navigationItem.title = "Confirmation"
        self.eventDateLbl.text = eventDate
        
        if typecontroller == "Meal Delivery Driver" || typecontroller == "Meal Delivery Non-Driver" {
            
            self.eventTypeLbl.text = "Meal Delivery"
            
                if Locale.current.languageCode == "fr"{
                
                self.eventTypeLbl.text = "Livraison"
                
                }
            
            

        } else if typecontroller == "Kitchen AM" {
            
            self.eventTypeLbl.text = "Kitchen AM"
            
                if Locale.current.languageCode == "fr"{
                
                self.eventTypeLbl.text = "Cuisine AM"
                
                }
            
        } else {
    
            self.eventTypeLbl.text = "Kitchen PM"
            
                if Locale.current.languageCode == "fr"{
                
                self.eventTypeLbl.text = "Cuisine PM"
                
                }
    
        }
        
        
        
        
        
        
        
        
        
        
        self.eventSlotLbl.text = eventSlot
        
        var image = UIImage(named: "home")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        borderView.layer.borderColor = UIColor(red: 104.0/255.0, green: 23.0/255.0, blue: 104.0/255.0, alpha: 1.0).cgColor

      
        Database.database().reference().child("user").queryOrdered(byChild: "key").queryEqual(toValue: userid).observe(.value, with: { (snapshot) in
            
            self.userInformation.removeAll()
            
            for child in snapshot.children {
                
                
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                
                // Fetch the user information and communicate to the global variable
                
                user_uid = childSnapshot?.key
                user_first_name = dict?["first_name"] as? String
                user_last_name = dict?["last_name"] as? String
                user_key = dict?["key"] as? String
                
                let user = UserInformation(user_first_name: user_first_name, user_last_name: user_last_name, user_key: user_key, user_uid: user_uid)
                
                self.userInformation.append(user)
                
                
            }
            
        })
        
        
        
    } // Ends viewDidLoad


    @IBAction func newSwitchTapped(_ sender: UISwitch) {
        
        if (sender.isOn == true){
            
            isOn = true
            
        } else {
            
            isOn = false
        }
    }
    
    
    @IBAction func driverSwitchTapped(_ sender: UISwitch) {
        
        if (sender.isOn == true){
            
            driverIsOn = true
            
        } else {
            
            driverIsOn = false
        }
        
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        var event_type_register: String = ""
        
        if typecontroller == "Meal Delivery Non-Driver" || typecontroller == "Meal Delivery Driver" {
            
            
            
            // Account for if the event takes place on a Saturday (check if the suffix of event_type is a "s")
            
            if eventType.suffix(1) == "s" {
                
                // If it is a Saturday
                
                if typecontroller == "Meal Delivery Driver" {
                    
                    // Driver is on AND it is Saturday
                    event_type_register = "delds"
                    
                    
                    
                } else {
                    
                    // Driver is off AND it is Saturday
                    event_type_register = "delis"
                    
                    
                }
                
                
                
            } else {
                
                // It is not Saturday
                
                if typecontroller == "Meal Delivery Driver" {
                    
                    event_type_register = "deldr"
                    
                    
                } else {
                    
                    // Driver is off (not Saturday)
                    
                    event_type_register = "deliv"
                    
                    
                }
                
            }
            
            
            
            let updateRef = Database.database().reference().child("event").child(String(self.eventint) + event_type_register + String(format: "%02d", slotNumberSelected))
            
            let childUpdates = [
                
                "key": userInformation[0].user_key as Any,
                "uid": userInformation[0].user_uid as Any,
                "first_name": userInformation[0].user_first_name as Any,
                "last_name": userInformation[0].user_last_name as Any,
                "note": self.additionalNotes.text as Any,
                "first_shift": self.isOn
                
                ] as [String : Any]
            
            updateRef.updateChildValues(childUpdates)
            
            
            let viewControllers = self.navigationController!.viewControllers
            for aViewController in viewControllers
            {
                if aViewController is CalenderVC
                {
                    let aVC = aViewController as! CalenderVC

                    aVC.registered = "yes"
                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                }
            } // End of the loop
            
            
            
        } else {
            
            
            
            if eventType.suffix(1) == "s" {
                
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
                    
                    let updateRef = Database.database().reference().child("event").child(String(self.eventint) + event_type_register + String(format: "%02d", slotNumberSelected))
                    
                    let childUpdates = [
                        
                        "key": userInformation[0].user_key as Any,
                        "uid": userInformation[0].user_uid as Any,
                        "first_name": userInformation[0].user_first_name as Any,
                        "last_name": userInformation[0].user_last_name as Any,
                        "note": self.additionalNotes.text as Any,
                        "first_shift": self.isOn
                    
                        ] as [String : Any]
                    
                    updateRef.updateChildValues(childUpdates)
                    
            
            let viewControllers = self.navigationController!.viewControllers
            for aViewController in viewControllers
            {
                if aViewController is CalenderVC
                {
                    let aVC = aViewController as! CalenderVC

                    aVC.registered = "yes"
                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                }
            } // End of the loop
            
            
            
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // Ends the class
