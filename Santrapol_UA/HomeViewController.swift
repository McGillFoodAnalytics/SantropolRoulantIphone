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
     let userid = Auth.auth().currentUser?.uid
    
    var useref = Database.database().reference().child("users");
    var events = Database.database().reference().child("EventRegister")

    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventSection
        let details: Model
        details = EventList[indexPath.row]
        cell.Date.text = details.eventdate
        cell.Location.text = details.loc
        cell.Slot.text = details.slot
        cell.Note.text = details.note
        
        if let btnDelete = cell.contentView.viewWithTag(102) as? UIButton {
                    btnDelete.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
            }
        return cell
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventList.count
    }
    
    private func tableView(tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
                guard let indexPath = tableView.indexPathForRow(at: point) else {
                    return
                }
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            var YesAction = UIAlertAction(title: "", style: .default)
            var NoAction = UIAlertAction(title: "", style: .default)
        
           if Locale.current.languageCode == "fr"{
            
                    alert = UIAlertController(title: "Confirmer 💔", message: "Êtes-vous sûr de vouloir supprimer cet événement?", preferredStyle: .alert)
            
                    YesAction = UIAlertAction(title: "Oui", style: .default) { (action) in
                
                    let details = self.EventList[indexPath.row]
                    let eventid = details.eventid ?? nil
                    let eventint = (details.eventid?.prefix(6) ?? nil) ?? ""
                    let eventStart = details.event_time_start
                
                    let eventDateTime = eventint + "," + eventStart!
                
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyMMdd,HH:mm"
                
                    let dateEvent = dateFormatterGet.date(from: eventDateTime)
                
                    let dateToday = Date()
            
                    let diffInMinutes = Calendar.current.dateComponents([.minute], from: dateToday, to: dateEvent!).minute
                
                
                    if diffInMinutes ?? 0 < 2880 {
                    
                        let alert = UIAlertController(title: "😭😭😭", message: "L'événement est dans moins de 48 heures. Veuillez nous appeler au (514) 284-9335 pour annuler.", preferredStyle: .alert)
                    
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                        alert.addAction(OKAction)
                    
                        self.present(alert, animated: true, completion: nil)
                    
                        return
                    
                    
                    } else {
                    
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
                    
                    
                        self.EventList.remove(at: indexPath.row)
                    
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                    }
                }
                NoAction = UIAlertAction(title: "Non", style: .default) { (action) in
                           
                    return
                           
                }
            }
           else{
            alert = UIAlertController(title: "Confirm 💔", message: "Are you sure you want to delete this event?", preferredStyle: .alert)
            
            YesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                    let details = self.EventList[indexPath.row]
                    let eventid = details.eventid ?? nil
                    let eventint = (details.eventid?.prefix(6) ?? nil) ?? ""
                    let eventStart = details.event_time_start
                
                    let eventDateTime = eventint + "," + eventStart!
                
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyMMdd,HH:mm"
                
                    let dateEvent = dateFormatterGet.date(from: eventDateTime)
                
                    let dateToday = Date()
            
                    let diffInMinutes = Calendar.current.dateComponents([.minute], from: dateToday, to: dateEvent!).minute
                
                
                    if diffInMinutes ?? 0 < 2880 {
                    
                        let alert = UIAlertController(title: "😭😭😭", message: "The event is less than 48 hours away. Please call us at (514) 284-9335 in order to cancel.", preferredStyle: .alert)
                    
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                        alert.addAction(OKAction)
                    
                        self.present(alert, animated: true, completion: nil)
                    
                        return
                    
                    
                    } else {
                    
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
                    
                    
                        self.EventList.remove(at: indexPath.row)
                    
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                    }
                }
                NoAction = UIAlertAction(title: "No", style: .default) { (action) in
                
                    return
                
                }
            }
     
            alert.addAction(YesAction)
            alert.addAction(NoAction)
            
            self.present(alert, animated: true, completion: nil)
        
    }
    
   
    var retrieveEvent = [String]()
    var ref:DatabaseReference?
    var dbHandle:DatabaseHandle?
    @IBOutlet weak var modifiedImage: UIImageView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.flashScrollIndicators()
        
        // Flash again with delays
        DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(50000)), execute: self.tableView.flashScrollIndicators)
        
        DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(50000*2)), execute: self.tableView.flashScrollIndicators)
        
        DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(50000*3)), execute: self.tableView.flashScrollIndicators)
        
        DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(50000*4)), execute: self.tableView.flashScrollIndicators)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false

        // Disables caching in the Firebase (useful if the user changes his personal info, perviously deleted events won't reappear in the page)
        Database.database().reference().keepSynced(true)

        self.navigationItem.title = ""
        
        
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "home")
        
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapEditButton))
        
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
                
                let date = dict?["event_date"] as? Int
                let event_time_start = dict?["event_time_start"] as? String
                let event_time_end = dict?["event_time_end"] as? String
                let note = dict?["note"] as? String
                
                let type = dict?["event_type"] as? String
                
                // Format the date
                let dateFormatterGet = DateFormatter()
                           dateFormatterGet.dateFormat = "yyyyMMdd"
                           
                           let dateFormatterPrint = DateFormatter()
                           dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
                           
                           if Locale.current.languageCode == "fr"{
                               
                               dateFormatterPrint.dateFormat = "dd MMMM yyyy"
                           }
                
                
                // Create a variable for the date
                
                let date_date_format = dateFormatterGet.date(from: String(date!))
                
                let date_text_format = dateFormatterPrint.string(from: date_date_format ?? Date())
                
                var type1: String? = ""
                
                // Make an if statement to determine the type to display
                
                if Locale.current.languageCode == "fr"{
                                            
                    if type?.prefix(3) == "del" {
                        type1 = "Livraison des repas"
                    } else if type?.prefix(4) == "kita" {
                        type1 = "Cuisine (matin)"
                    } else {
                        type1 = "Cuisine (après-midi)"
                    }
                                                      
                } else {
                    
                    if type?.prefix(3) == "del" {
                        type1 = "Meal Delivery"
                    } else if type?.prefix(4) == "kita" {
                        type1 = "Kitchen AM"
                    } else {
                        type1 = "Kitchen PM"
                    }
                    
                    
                }
                

                
                let slot = event_time_start! + "-" + event_time_end!
                
                
                let event = Model(loc: type1, eventdate: date_text_format, slot: slot, event_time_start: event_time_start, event_time_end: event_time_end, eventid: eventid, note: note)
                
                self.EventList.append(event)
                
                self.tableView.reloadData()
                
                
            }
            
        })
        
      //  tableView.dataSource = self
    //    tableView.delegate = self
        
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
