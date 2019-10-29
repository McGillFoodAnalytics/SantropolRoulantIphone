//
//  SecondViewController.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-02-06.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase //for storing data
import FirebaseAuth //for creating new user

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    
    
    var useref = Database.database().reference().child("user");
    
    @IBOutlet weak var FirstName: UITextField!
    
    
    
    @IBOutlet weak var LastName: UITextField!
   
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    
    @IBOutlet weak var ErrMsg: UILabel!
    
    
  
    
    @IBAction func JoinNowTapped(_ sender: UIButton) {
        addUsers()
        //to add new user in database and create new user for authentication
        //print("Calling function addUsers ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        FirstName.delegate = self
        LastName.delegate = self
        Email.delegate = self
        Password.delegate = self
        
        
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func addUsers() {
        //useref = Database.database().reference().child("Users")
        //let key = useref.child(user.uid).key
        
        if let email = Email.text,
        let pass = Password.text, let _ = FirstName.text
        { Auth.auth().createUser(withEmail: email, password: pass)  { (user, error) in
    
                //Check error and show error message
                if error != nil
                {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .invalidEmail:
                            print("Please enter a valid email")
                            self.ErrMsg.text = "Please enter a valid email"
                        case .emailAlreadyInUse:
                            print("The email is already in use with another account")
                            self.ErrMsg.text = "The email is already in use with another account"
                        default:
                            print("Can't create new user!")
                            self.ErrMsg.text = "Can't create new user!"
                        }
                        
                    }
            }
                else
                {
                    let phone_number = 5144187718
                    let userid = self.LastName.text!.prefix(2).lowercased() + String(phone_number)
                    let key = Auth.auth().currentUser!.uid
                    let user = ["first_name":self.FirstName.text! as String,"last_name":self.LastName.text! as String,"phone_number": phone_number, "email":self.Email.text! as String, "key": key as String] as [String : Any]
                    self.useref.child(userid).setValue(user) //add user details in DB
                    //print("User Details are ",user)
                    
                    self.performSegue(withIdentifier: "goToLogin", sender: self)
                }
            
        
    }


}
}
    
    
}
