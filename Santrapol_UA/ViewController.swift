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
    
    var location: String!
    var dummy: String!
    var registered: String! = ""
    var eventtype: String!
    var eventdate: Int!
    // var note: String!

    
    var checked = [Bool]()
    
    
    
    var availableDates = [EventDisplay]()
    var test = [Model]()
    var dummy_array = [DummyArray]()
    
    var retrieveEvent = [String]()
    var ref:DatabaseReference?
    var dbHandle:DatabaseHandle?
    let userid = Auth.auth().currentUser!.uid
    var usercount: [Int] = []
    
    var eventuserscount = Int()
    var location_start_query: String = ""
    var location_end_query: String = ""
    var location_start_query_1: String = ""
    var location_end_query_1: String = ""
 
  
    //var cnt: Int = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        if registered == "yes"{
            
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            
            if Locale.current.languageCode == "fr"{
                alert = UIAlertController(title: "Succès", message: "Enregistré avec succès! Voulez-vous vous inscrire pour un autre quart?", preferredStyle: .alert)
            }
            else{
                alert = UIAlertController(title: "Success", message: "Registered successfully! Do you want to register for another shift?", preferredStyle: .alert)
            }
            
            
           
            let YesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    
                    self.registered = ""
                    
            }
            
            
          //  let YesAction = UIAlertAction(title: "Yes", style: .cancel, handler: nil)
            
            let NoAction = UIAlertAction(title: "No", style: .default) { (action) in
                
            /*    let secondViewController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
                self.present(secondViewController, animated: true, completion: nil) */
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : HomeViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                
                let navigationController = UINavigationController(rootViewController: vc)
                
                self.present(navigationController, animated: true, completion: nil)
                
            }

            alert.addAction(YesAction)
            alert.addAction(NoAction)
            
            self.present(alert, animated: true, completion: nil)
            
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
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = location
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "Screen Shot 2019-01-27 at 1.05.03 PM")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true // Displays a loading spinner
        tblList.dataSource = self
        
        ref = Database.database().reference().child("event")

        
        
        if location == "Meal Delivery" {
            
            location_start_query = "delis"
            location_end_query = "deliv"
            
            location_start_query_1 = "deldr"
            location_end_query_1 = "deliv"
            
            
        } else if location == "Kitchen AM" {
            
            location_start_query = "kitam"
            location_end_query = "kitas"
            
            location_start_query_1 = "kitam"
            location_end_query_1 = "kitas"
            
        } else {
            
            location_start_query = "kitpm"
            location_end_query = "kitps"
            
            location_start_query_1 = "kitpm"
            location_end_query_1 = "kitps"
            
        }
        
        
        
        
        self.ref?.queryOrdered(byChild: "event_type").queryStarting(atValue: location_start_query).queryEnding(atValue: location_end_query).observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                let date = dict?["event_date_txt"] as? String
                let event_time_start = dict?["event_time_start"] as? String
                let event_time_end = dict?["event_time_end"] as? String
                let event_int = dict?["event_date"] as? Int ?? 0
                let event_type = dict?["event_type"] as? String
                let note = dict?["note"] as? String
                
                Database.database().reference().child("event").queryOrderedByKey().queryStarting(atValue: String(event_int) + self.location_start_query_1 + "01").queryEnding(atValue: String(event_int) + self.location_end_query_1 + "99").observe(.value, with: { (snapshot) in
                    

                    
                    //   queryOrdered(byChild: "event_date").queryEqual(toValue: self.eventint)
                    
                    self.dummy_array.removeAll()
                    
                    for child in snapshot.children {
                        
                        let childSnapshot = child as? DataSnapshot
                        let dict = childSnapshot?.value as? [String:Any]
                      //  let uid = dict?["uid"] as? [String:Any]
                        let user_id = dict?["key"] as? String
                        
                       let user  = DummyArray(user_id: user_id)
                        self.dummy_array.append(user)
                        
                    }
                    
                     // Get the count in the dummy array
                    
                    let number_user_array = self.dummy_array.map {$0.user_id}
                    
                    let count_nonNils = number_user_array.filter({$0 != "nan"}).count
                    
                    let available_space = number_user_array.count - count_nonNils
                    
                    
                        
                    let event = EventDisplay(eventdate: date, event_start: event_time_start, event_end: event_time_end, event_int: event_int, event_type: event_type, cap: available_space)
                        
                        self.availableDates.append(event)
                        
                        self.availableDates = self.availableDates.unique{$0.eventdate ?? ""}
                        
                        self.availableDates.sort { $0.event_int ?? 0 < $1.event_int ?? 0 }
                    
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true // Hides the loading spinner
                        self.tblList.reloadData()   
                })
            }
        })
    }
    
    
    
    
    
    var selection = [Int]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableDates.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell") as! AvailableEvents
        
            let details: EventDisplay
            details = availableDates[indexPath.row]

            cell.Date.text = details.eventdate
        cell.slot.text = details.event_start! + "-" + details.event_end!
        
        // Need to find a way to determine the number of spots available
        
        cell.cap.text = "\(details.cap ?? 0) spots available"
        
        // cell.note.text = details.note
        
        return cell
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToListVolunteers") {
            let vc = segue.destination as! ListVolunteer
            vc.eventint = eventdate
            vc.eventtype = eventtype
            vc.dummy = dummy
            vc.typecontroller = location
        }
    }
    
 
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 /*       var targetid = availableDates[indexPath.row].loc
        var eventcap = availableDates[indexPath.row].cap
        var driverCap = availableDates[indexPath.row].driverCap */
        
        eventdate = availableDates[indexPath.row].event_int
        eventtype = availableDates[indexPath.row].event_type
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "goToListVolunteers", sender: self)

    }
    
    @IBOutlet weak var PageHeader: UINavigationItem!
    


    @IBAction func backTapped(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let VolunteerSignupScreen: VolunteerSignup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VolunteerSignupScreen") as! VolunteerSignup
        
     //   VolunteerSignupScreen.dummy = dummy // Identifier to be capable of identifying where the user comes from for the purpose of transitions

        self.present(VolunteerSignupScreen, animated: false, completion: nil)
        
        
    }
        
        
    }

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}


