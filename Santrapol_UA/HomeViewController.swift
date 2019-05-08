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
        print("Count is", EventList.count)
        
        return cell
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventList.count
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let Details = EventList[indexPath.row]
            Details.eventdate?.removeAll()
            Details.loc?.removeAll()
        }
    }
   
    var retrieveEvent = [String]()
    var ref:DatabaseReference?
    var dbHandle:DatabaseHandle?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        NavigationBar.app.setUpNavigationBarItems(PageHeader: PageHeader, location: "Home")

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference().child("EventRegister")
        //Retrieve the events list
        
        
        ref?.child(userid).queryOrderedByKey().observe(.childAdded
            , with: { (snapshot) in
            if snapshot.childrenCount>0 {
                //self.EventList.removeAll()
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    //let eventObject = .value as? [String: AnyObject]
                    //print(eventObject)
                    let location = snapshot.key
                    let date = events.key
                    
                    let event1 = events.value as? [String:Any]
                    let slot = event1?["slot"] as? String
                    
                    
                    //let date = slot?[events.key]
                    //let actualslot = slot?[events.value]
                    //print("Location is", location)
                    //print("EventDate is ",date)
                    //print("slot is ", slot)
                    //print("test is" ,test1)
                    let event = Model(loc: location , eventdate: date as? String, slot: slot as? String)
                    self.EventList.append(event)
                }
                print(self.EventList.count)
            self.tableView.reloadData()
            }
        })
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
