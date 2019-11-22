//
//  LogInEnvironment.swift
//  Santrapol_UA
//
//  Created by G Lapierre on 2019-07-31.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseAuth  //for User Authentication
import FirebaseDatabase
import SVProgressHUD

class LogInEnvironment: UIViewController {

    
    @IBOutlet weak var viewLogIn: UIView!
    @IBOutlet weak var logInLabel: UILabel!
    
    @IBOutlet weak var userNameField: UITextField!
    //   @IBOutlet weak var userNameField: UITextField!
    
    
    @IBOutlet weak var PasswordField: UITextField!
    
   // @IBOutlet weak var PasswordField: UITextField!
    
    @IBOutlet weak var showToggle: UIButton!
    
  //  @IBOutlet weak var showToggle: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool){
        
      userNameField.becomeFirstResponder()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            for constraint in viewLogIn.constraints {
                if constraint.identifier == "myConstraint" {
                    constraint.constant =  ( (CGFloat(logInLabel.text!.count) - 6) * (0.2/6) ) * UIScreen.main.bounds.width
                
                    print(logInLabel.text!.count)
                }
            }
            viewLogIn.layoutIfNeeded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        userNameField.frame.size.width = UIScreen.main.bounds.width - 58
        
        PasswordField.frame.size.width = UIScreen.main.bounds.width - 58
        
        
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem!.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 14)!], for: .normal)
        
        navigationItem.rightBarButtonItem!.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 14)!], for: .highlighted)

        
        userNameField.setBottomBorder(withColor: UIColor.white)
        PasswordField.setBottomBorder(withColor: UIColor.white)

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func showToggleTapped(_ sender: UIButton) {
        
        if PasswordField.isSecureTextEntry == false {
            
            // The button is showing text and now we want to hide it
            PasswordField.isSecureTextEntry = true
            UIView.performWithoutAnimation {
                
                if Locale.current.languageCode == "fr"{
                    showToggle.setTitle("Montrer", for: .normal)
                }
                else{
                    showToggle.setTitle("Show", for: .normal)
                }
                showToggle.layoutIfNeeded()
            }
            
        } else {
            
            // The password is hidden and now we want to display it
            PasswordField.isSecureTextEntry = false
            UIView.performWithoutAnimation {
                
                if Locale.current.languageCode == "fr"{
                    showToggle.setTitle("Cacher", for: .normal)
                }
                else{
                    showToggle.setTitle("Hide", for: .normal)
                }
                showToggle.layoutIfNeeded()
            }
        }
    }

    
    @IBAction func logInTapped(_ sender: Any) {
        
        SVProgressHUD.setForegroundColor(UIColor(red: 104.0/255.0, green: 23.0/255.0, blue: 104.0/255.0, alpha: 1.0))
        SVProgressHUD.show()
        
        self.navigationController?.view.isUserInteractionEnabled = false
        
        // testing system language detection
        /*
        if Locale.current.languageCode == "fr"{
            print("Your system language is French")
        }
        else{
            print("Your system langauge is English")
        }
        */
       
        //var username: String
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        
        if userNameField.text == "" {
            SVProgressHUD.dismiss()
            
            if Locale.current.languageCode == "fr"{
                showAlert(message: "L'utilisateur n'existe pas")
            }
            else{
                showAlert(message: "User doesn't exist")
            }
            
            self.navigationController?.view.isUserInteractionEnabled = true


            return
            
            // Check if username input contains special characters (not supported by Firebase)
        } else if userNameField.text!.rangeOfCharacter(from: characterset.inverted) != nil {
            
            SVProgressHUD.dismiss()
            
            if Locale.current.languageCode == "fr"{
                showAlert(message: "L'utilisateur n'existe pas")
            }
            else{
                showAlert(message: "User doesn't exist")
            }
        
            self.navigationController?.view.isUserInteractionEnabled = true

            return
            
        }
        
        
        
        
        Database.database().reference().child("user").child(userNameField.text!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let email1 = snapshot.value
            
            
            if let email = email1, let pass = self.PasswordField.text {
                Auth.auth().signIn(withEmail: email as? String ?? "invalidemail@hotmail.com", password: pass) { (user, error) in
                    // ...
                    if error != nil
                    {
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            
                            switch errCode {
                            case .invalidEmail:
                                print("Invalid email")
                                
                                if Locale.current.languageCode == "fr"{
                                    self.showAlert(message: "S'il vous plaît entrez une addresse email valide")
                                }
                                else{
                                    self.showAlert(message: "Please enter a valid email")
                                }
                                
                            case .userDisabled:
                                
                                if Locale.current.languageCode == "fr"{
                                    self.showAlert(message: "L'utilisateur est désactivé")
                                }
                                else{
                                    self.showAlert(message: "User is disabled")
                                }
                                

                            case .wrongPassword:
                                if Locale.current.languageCode == "fr"{
                                    self.showAlert(message: "Mot de passe incorrect")
                                }
                                else{
                                    self.showAlert(message: "Incorrect Password")
                                }
                                
     
                            default:
                                
                                if Locale.current.languageCode == "fr"{
                                    self.showAlert(message: "L'utilisateur n'existe pas")
                                }
                                else{
                                    self.showAlert(message: "User doesn't exist")
                                }
                            }
                            
                            SVProgressHUD.dismiss()
                            self.navigationController?.view.isUserInteractionEnabled = true
                        }
                        
                        
                    }
                    else {
                        
                        
                        
                        let userid = Auth.auth().currentUser!.uid
                        //else {return}
                        print(userid)
                        
                        self.defaults.set(true, forKey: "codeEntered")
                        
                        self.performSegue(withIdentifier: "goToMainPage", sender: self)
                        
                        SVProgressHUD.dismiss()
                        self.navigationController?.view.isUserInteractionEnabled = true
                    }
                    
                } // Ends the second if statement
                
                
                
            } // Ends first if statement
            
            
            
        })
        
        
    } // Ends tap function
    

   
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToRecoverPass", sender: self)
    }
    
    func showAlert(message:String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

}



class RecoverPass: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var resetPassOutlet: UIButton!
    
    override func viewDidAppear(_ animated: Bool){
        
         emailField.becomeFirstResponder()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetPassOutlet.titleLabel?.minimumScaleFactor = 0.50;
        self.resetPassOutlet.titleLabel?.numberOfLines = 1;
        self.resetPassOutlet.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.resetPassOutlet.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters;
       
        
    emailField.frame.size.width = UIScreen.main.bounds.width - 58
        
        emailField.setBottomBorder(withColor: UIColor.white)
    }
    
    
    @IBAction func resetPassTapped(_ sender: Any) {
        
        if emailField.text?.isEmpty == false
        {
            let email = emailField.text
            
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                
                if error != nil {
                    
                let userMsg:String = error!.localizedDescription
                    
                self.showAlert(message: userMsg)

                }
                else {
                    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    
                    if Locale.current.languageCode == "fr"{
                        alert = UIAlertController(title: "Success", message: "Un email a été envoyé à \(email ?? "test")", preferredStyle: .alert)
                        
                    }
                    else{
                        alert = UIAlertController(title: "Success", message: "An email has been sent to \(email ?? "test")", preferredStyle: .alert)
                    }
                    
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)

                }
                return
            }
        }
        else {
            if Locale.current.languageCode == "fr"{
                self.showAlert(message: "Veuillez entrer une adresse email valide")
            }
            else{
                self.showAlert(message: "Please enter valid email address")
            }
        }
    }
    
    func showAlert(message:String){
        var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if Locale.current.languageCode == "fr"{
            alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        }
        else{
            alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        }
        
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}
