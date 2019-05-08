//
//  ViewController.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-13.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblList: UITableView!
    var Home: UIImage? = UIImage(named:"Screen Shot 2019-01-27 at 1.05.03 PM")?.withRenderingMode(.alwaysOriginal)
    var Profile: UIImage? = UIImage(named: "icons8-customer-filled-50-2")?.withRenderingMode(.alwaysOriginal)
    
    var location: String!
    
 

    
    var checked = [Bool]()
    var availableDates = [Model]()
    
    var retrieveEvent = [String]()
    var ref:DatabaseReference?
    var dbHandle:DatabaseHandle?
    let userid = Auth.auth().currentUser!.uid
    
  
    //var cnt: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
         PageHeader.title = location
        setUpNavigationBarItems()
        
        // Do any additional setup after loading the view, typically from a nib.
        tblList.dataSource = self
        print("Location in ViewController is ", location)
        ref = Database.database().reference().child(location)
        //Retrieve the events list
        //print(ref)
        ref?.observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount>0 {
                self.availableDates.removeAll()
                
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    let eventObject = events.value as? [String: AnyObject]
                let date1 = eventObject?["date"]
                    let slot = eventObject?["slot"]
                    
                    //let location = eventObject?["Loc"]
                    let event = Model(availableDate: date1 as? String, slot: slot as? String)
                    self.availableDates.append(event)
                    //print(date1)
                }
                self.tblList.reloadData()
            }
        }
        
        
        )
        
        
        
        
    }
    
    var selection = [Int]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableDates.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell")
        
        if let lbl = cell?.contentView.viewWithTag(1) as? UILabel {
            let details: Model
              details = availableDates[indexPath.row]
            lbl.text = details.availableDate
        
        cell?.detailTextLabel?.text = details.slot
           
            
            
            
        }
        
        return cell!
    }
    
   


    
    
 
   
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setUpNavigationBarItems()
    {
       
        let HomeButton = UIButton(type: .system)
        
        HomeButton.setImage( Home, for: .normal)
        //HomeButton.setTitle("Home", for: .normal)
        
        HomeButton.addTarget(self, action: #selector(HomeButtonTapped), for: .touchUpInside)
        PageHeader.leftBarButtonItem = UIBarButtonItem(customView: HomeButton)
        let ProfileButton = UIButton(type: .system)
        ProfileButton.setImage(Profile, for: .normal)
        ProfileButton.addTarget(self, action: #selector(ProfileButtonTapped), for: .touchUpInside)
        PageHeader.rightBarButtonItem = UIBarButtonItem(customView: ProfileButton)
        
        
    }
    
    @objc func HomeButtonTapped(sender: UIBarButtonItem) {
        let Home: HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as! HomeViewController
        //DisplayVC.location = "RoulantRooftop"
        self.present(Home, animated: true, completion: nil)
    }
    
    @objc func ProfileButtonTapped(sender: UIBarButtonItem)  {
        let Profile: ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        //DisplayVC.location = "RoulantRooftop"
        self.present(Profile, animated: true, completion: nil)
        
    }
    
  
    
    @IBOutlet weak var PageHeader: UINavigationItem!
    
   @IBAction func SubmitTapped(_ sender: UIButton) {
        let selectedindexlist = tblList.indexPathsForSelectedRows
        //print("selectedindex",selectedindexlist)
    
      var EventRegister = Database.database().reference().child("EventRegister").child(userid).child(location)
    var selecteddates: Model
    
    for i in selectedindexlist! {
        //cnt=cnt+1
        selecteddates = availableDates[i.row]
        
        //print("count in for loop", cnt)
       // print("datesselected", selecteddates.availableDate)
        
        let event = ["slot": selecteddates.slot as! String]
       // print(event)
        EventRegister.child(selecteddates.availableDate as! String).setValue(event) //add user details in DB
        
        
    }
    
   
    }
    
    
    
    
}



