//
//  FirstViewController.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-02-06.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseAuth  //for User Authentication
import FirebaseDatabase

import JTAppleCalendar //for calendar setup

class FirstViewController: UIViewController {
    
    

    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var LogIn: UIButton!
    
    @IBOutlet weak var ForgotPassword: UIButton!
    
    
    @IBAction func ResetPassword(_ sender: UIButton) {
    self.performSegue(withIdentifier: "ForgotPassword", sender: self)
    }
    
    
    @IBOutlet weak var ErrorMsg: UILabel!
    
    
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    //let formatter = DateFormatter()
    
    
    
            
    
    
    
    var isSignIn:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        
    }
    
  
    @IBAction func SignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
        
    }
    
    
    /*override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "gotoHome"
        { if UserName.text.isEmpty == true {
            
            
            return false
        }
        else {
            
            }
        return true
    }*/
    
    @IBAction func LogInButton(_ sender: Any) {
        if let email = UserName.text, let pass = Password.text {
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                // ...
                if error != nil
                {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
             
                        switch errCode {
                        case .invalidEmail:
                            print("invalid email")
                  self.ErrorMsg.text = "Please enter valid email"
                            
                            
                        case .userDisabled:
                            print("User is disabled")
                            self.ErrorMsg.text = "User is Disabled"
                        case .wrongPassword:
                            print("Incorrect Password")
                            self.ErrorMsg.text = "Incorrect Password"
                        default:
                            print("Can't login!")
                         self.ErrorMsg.text = "User doesn't exist. Please sign up for a new user"
                        }
                        
                    }
           
                    
                }
                else {
                    
                   
                    let userid = Auth.auth().currentUser!.uid
                        //else {return}
                print(userid)
                    self.performSegue(withIdentifier: "goToHome", sender: self)
            }
                
    }
    
    
    
   
    
}
    } //Closing bracket for Login Button
   /* let firebaseAuth = Auth.auth()
    do {
    try firebaseAuth.signOut()
    } catch let signOutError as NSError {
    print ("Error signing out: %@", signOutError)
    } */
  
}





extension Date {
    
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
}


/*extension FirstViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell
        cell.dateLabel.text = cellState.text
    }
    
    
    
    
    
    
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Date()
        let endDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: 180, to: startDate, options: [])!

        //let endDate = formatter.date(from: "2020 12 31")
        let parameters = ConfigurationParameters(startDate: startDate , endDate: endDate)

        return parameters



    }
    
}
 */


