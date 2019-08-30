//
//  HomeViewController.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-08.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var PageHeader: UINavigationItem!
    @IBOutlet weak var Slot: UILabel!
    var EventList = [Model]()
     let userid = Auth.auth().currentUser!.uid
    
    var useref = Database.database().reference().child("users");
    var events = Database.database().reference().child("EventRegister")
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventSection
        
        let details: Model
        details = EventList[indexPath.row]
        cell.Date.text = details.eventdate
        cell.Location.text = details.loc
        cell.Slot.text = details.slot
        
        return cell
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventList.count
    }

    
   /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Action to delete the entry from the firebase database
        
        let details = EventList[indexPath.row]
        
        let eventid = details.eventid ?? nil
        let idofuser = userid
        
        let key = eventid! + userid
  
        
        let testalert = UIAlertController(title: "Unregister", message: "Are you sure you want to unregister from this shift?", preferredStyle: .alert)
        
        let testOKAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            
          //  Database.database().reference().child("event").child(eventid!).child("uid").removeValue()
            
            Database.database().reference().child("event").child(eventid!).child("uid").setValue("nan")
            
            Database.database().reference().child("event").child(eventid!).child("note").setValue("nan")
            
        Database.database().reference().child("event").child(eventid!).child("first_shift").setValue("false")

            
            
            let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
            self.present(secondViewController, animated: false, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        testalert.addAction(testOKAction)
        testalert.addAction(cancelAction)
        
        self.present(testalert, animated: true, completion: nil)

    } */
    
    private func tableView(tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let details = EventList[indexPath.row]
            let eventid = details.eventid ?? nil
            
            let deleteRef = Database.database().reference().child("event").child(eventid!)
            
            let childUpdates = [
            
                "first_name": "",
                "last_name": "",
                "key": "nan",
                "uid": "nan",
                "note": "",
                "first_shift": false
            
                ] as [String : Any]
            
            // Performs all the changes simultaneously
            deleteRef.updateChildValues(childUpdates)
            
            /* Database.database().reference().child("event").child(eventid!).child("first_name").setValue("")
            
            Database.database().reference().child("event").child(eventid!).child("last_name").setValue("")
            
            Database.database().reference().child("event").child(eventid!).child("key").setValue("nan")
            
            Database.database().reference().child("event").child(eventid!).child("uid").setValue("nan")
            
            Database.database().reference().child("event").child(eventid!).child("note").setValue("nan")
            
        Database.database().reference().child("event").child(eventid!).child("first_shift").setValue("false") */
            
            EventList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
    }
    
   
    var retrieveEvent = [String]()
    var ref:DatabaseReference?
    var dbHandle:DatabaseHandle?
    
    @objc func didTapEditButton(sender: AnyObject) {
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : HomePage = storyboard.instantiateViewController(withIdentifier: "HomePage") as! HomePage
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disables caching in the Firebase (useful if the user changes his personal info, perviously deleted events won't reappear in the page)
        Database.database().reference().keepSynced(true)

        self.navigationItem.title = ""
        
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "Screen Shot 2019-01-27 at 1.05.03 PM")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        


        

        // Do any additional setup after loading the view.
        
        //Filter the attendee table by User ID to get event ID the user is registered
       ref = Database.database().reference().child("attendee")
        
        
        Database.database().reference().child("event").queryOrdered(byChild: "key").queryEqual(toValue: userid).observe(.value, with: { (snapshot) in
            
            self.EventList.removeAll()
            
            for child in snapshot.children {
                
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                let eventid = childSnapshot?.key // Gives the folder in which the event is contained
                
                let date = dict?["event_date_txt"] as? String
                let event_time_start = dict?["event_time_start"] as? String
                let event_time_end = dict?["event_time_end"] as? String
                
                let type = dict?["event_type"] as? String
                
                var type1: String? = ""
                
                // Make an if statement to determine the type to display
                
                if type?.prefix(3) == "del" {
                    type1 = "Meal Delivery"
                } else if type?.prefix(4) == "kita" {
                    type1 = "Kitchen AM"
                } else {
                    type1 = "Kitchen PM"
                }
                
                let slot = event_time_start! + "-" + event_time_end!
                
                
                let event = Model(loc: type1, eventdate: date, slot: slot, eventid: eventid)
                self.EventList.append(event)
                
                self.tableView.reloadData()
                
                
            }
            
        })
        
        
     }
    
    
    @IBAction func backTapped(_ sender: Any) {
       
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        
        let HomePage: HomePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as! HomePage
        
        present(HomePage, animated:false, completion: nil)
        
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        
        performSegue(withIdentifier: "goToVolunteerEventSignUp", sender: self)
        
        
    }
    
}
