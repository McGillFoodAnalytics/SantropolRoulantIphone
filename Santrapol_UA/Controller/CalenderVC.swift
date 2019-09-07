//
//  ViewController.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

enum MyTheme {
    case light
    case dark
}

// JTApple Calendar to potentially replace this part

class CalenderVC: UIViewController, CalenderDelegate, BottomSheetDelegate  {
    
    // This is a test for GitHub
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var container: UIView!
    var stringy: String? = "5"
    var registered: String! = ""
    var typecontroller: String! = ""
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonthIndex = Calendar.current.component(.month, from: Date())
    var firstWeekDayOfMonth = 0
    
    var containerViewController: BottomSheetViewController?
    static var bookedSlotDate = [Int]()
    var location_start_query: String = ""
    var location_end_query: String = ""
    var datesImportant = [Model]()
    
    @objc func didTapEditButton(sender: AnyObject) {
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : HomePage = storyboard.instantiateViewController(withIdentifier: "HomePage") as! HomePage
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if registered == "yes"{
            SVProgressHUD.setForegroundColor(UIColor(red: 104.0/255.0, green: 23.0/255.0, blue: 104.0/255.0, alpha: 1.0))
            SVProgressHUD.show()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if registered == "yes"{
            SVProgressHUD.dismiss()
            
            
            /*  let alert = UIAlertController(title: "Success", message: "Registered successfully! Do you want to register for another event?", preferredStyle: .alert)
             
             
             let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
             
             alert.addAction(OKAction)
             present(alert, animated: true, completion: nil) */
            //emoji test
            let alert = UIAlertController(title: "Success ❤️🎉", message: "Registered successfully! Do you want to register for another shift?", preferredStyle: .alert)
            
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
        
        if isBeingPresented || isMovingToParent {
            
            firstWeekDayOfMonth = getFirstWeekDay()
            
            // This selects today's date by default in the app
            let indexPathForFirstRow = IndexPath(row: Calendar.current.component(.day, from: Date()) + firstWeekDayOfMonth - 2, section: 0)
            calenderView.myCollectionView.selectItem(at: indexPathForFirstRow, animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            calenderView.collectionView(calenderView.myCollectionView, didSelectItemAt: indexPathForFirstRow)
            // This is the first time this instance of the view controller will appear
        } else {
            
            // This controller is appearing because another was just dismissed
            
        }
    }
    
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 7 ? 1 : day
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Load stuff from the firebase and append to the bookedSlotDate array
        
        Database.database().reference().child("event").queryOrdered(byChild: "event_type").queryStarting(atValue: location_start_query).queryEnding(atValue: location_end_query).observe(.value, with: { (snapshot) in
            
            self.datesImportant.removeAll()
            
            for child in snapshot.children {
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                let is_important_event = dict?["is_important_event"] as? Bool
                
                let eventint = dict?["event_date"] as? Int
                
                let intEvent = Model(is_important_event: is_important_event, event_date: eventint)
                
                
                
                self.datesImportant.append(intEvent)

                
    
                
                // Remove duplicates (optional step)
               // self.verificationArray = self.verificationArray.unique()
            }
            

            
            let interest = self.datesImportant.filter({$0.is_important_event! == true})
            
            CalenderVC.bookedSlotDate = interest.map {$0.event_date!}
            
            CalenderVC.bookedSlotDate = CalenderVC.bookedSlotDate.unique()
            
            print(CalenderVC.bookedSlotDate)
            
            // This ensures that the view is added AFTER the firebase actions are performed
            
            self.view.addSubview(self.calenderView)
            self.calenderView.delegate = self
            self.calenderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive=true
            self.calenderView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive=true
            self.calenderView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive=true
            self.calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
            
            self.view.sendSubviewToBack(self.calenderView)
            
            
        })
        
        
        
       // CalenderVC.bookedSlotDate = [200712]
        
        
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "Screen Shot 2019-01-27 at 1.05.03 PM")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        stringy = "this is a test"
        
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        
        
        self.title = "Select a Date"
        //  self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Picture2")!)
        
        
    /*    view.addSubview(calenderView)
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        self.view.sendSubviewToBack(calenderView) */
        
        //  self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightBarBtnAction))
        
        //   self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BottomSheetViewController{
            vc.bottomSheetDelegate = self
            vc.parentView = container
            
        }
        
        if segue.identifier == "test" {
            containerViewController = segue.destination as? BottomSheetViewController
            containerViewController?.test = self.stringy ?? "it did not work"
            containerViewController?.typecontroller = self.typecontroller
            
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("does it work?")
    }
    
    func updateBottomSheet(frame: CGRect) {
        container.frame = frame
        //        backView.frame = self.view.frame.offsetBy(dx: 0, dy: 15 + container.frame.minY - self.view.frame.height)
        //        backView.backgroundColor = UIColor.black.withAlphaComponent(1 - (frame.minY)/200)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        print(123)
    }
    
    @objc func dismissVC(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    lazy var  calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
    
    func didTapDate(date: String, dateInt: String, available: Bool) {
        if available == true {
            print(date)
            stringy = String(dateInt)
            let stringa = String(date)
            
            containerViewController?.test = self.stringy!
            containerViewController?.eventint = Int(self.stringy!)
            containerViewController?.dateLabel.text = stringa
            
            //  containerViewController?.viewDidLoad()
            containerViewController?.viewWillAppear(true)
            containerViewController?.viewDidLoad()
        } else {
            showAlert()
        }
    }
    
    
    
    fileprivate func showAlert(){
        let alert = UIAlertController(title: "Unavailable", message: "This slot is already booked.\nPlease choose another date or time. 😔", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

