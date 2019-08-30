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
import SVProgressHUD

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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    
    
    var isSignIn:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    


  
    @IBAction func SignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
        
    }
    
    
    @IBAction func LogInButton(_ sender: Any) {
        
        SVProgressHUD.setForegroundColor(UIColor(red: 104.0/255.0, green: 23.0/255.0, blue: 104.0/255.0, alpha: 1.0)) 
        SVProgressHUD.show()
        
        var username: String
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        


        
        if UserName.text == "" {
            
            self.ErrorMsg.text = "User doesn't exist"
            SVProgressHUD.dismiss()// Dummy username to prevent the app from crashing
            return
            
            // Check if username input contains special characters (not supported by Firebase)
        } else if UserName.text!.rangeOfCharacter(from: characterset.inverted) != nil {
            
            self.ErrorMsg.text = "User doesn't exist"
            SVProgressHUD.dismiss()
            return
            
        }
            
            

        
        Database.database().reference().child("user").child(UserName.text!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let email1 = snapshot.value
        
        
            if let email = email1, let pass = self.Password.text {
                Auth.auth().signIn(withEmail: email as? String ?? "invalidemail@hotmail.com", password: pass) { (user, error) in
                // ...
                if error != nil
                {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
             
                        switch errCode {
                        case .invalidEmail:
                            print("Invalid email")
                  self.ErrorMsg.text = "Please enter valid email"
                            
                            
                        case .userDisabled:
                            print("L'utilisateur est désactivé / User is disabled")
                            self.ErrorMsg.text = "User is disabled"
                        case .wrongPassword:
                            print("Incorrect Password")
                            self.ErrorMsg.text = "Incorrect Password"
                        default:
                            print("Can't login!")
                         self.ErrorMsg.text = "User doesn't exist"
                        }
                        
                        SVProgressHUD.dismiss()
                        
                    }
           
                    
                }
                else {
                    

                   
                    let userid = Auth.auth().currentUser!.uid
                        //else {return}
                print(userid)
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    
                    SVProgressHUD.dismiss()
            }
                
    } // Ends the second if statement
    
   
    
         } // Ends first if statement
            

            
                                    })
        
        
            
    } // Ends the tap function
  
} // Ends the class



