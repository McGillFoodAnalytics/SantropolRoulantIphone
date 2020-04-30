//
//  ResetPassword.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-18.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPassword: UIViewController {

    
    
    @IBOutlet weak var EmailFgtPwd: UITextField!
    @IBAction func ResetPwdTapped(_ sender: UIButton) {
        if EmailFgtPwd.text?.isEmpty == false
        {
            let email = EmailFgtPwd.text
            
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                
                if error != nil
                {let userMsg:String = error!.localizedDescription
                    self.displayMessage(userMessage:userMsg)
                }
                else {
                    
                    let userMsg:String = "Un courriel a été envoyé à l'adresse / An email has been sent to \(email ?? "test")"
                    self.displayMessage(userMessage:userMsg)
                }
                return
            }
        }
        else {
            let userMsg = "Veuillez indiquer une adresse de courriel valide / Please enter valid email address"
            self.displayMessage(userMessage: userMsg)
        }
    }


override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Reset Password"

    
    // Do any additional setup after loading the view.
}

func displayMessage(userMessage:String)
{
    let Alert = UIAlertController(title: "Message", message: userMessage, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {action in
        self.dismiss(animated: true, completion: nil)
        
    }
    Alert.addAction(okAction)
    self.present(Alert, animated: true, completion: nil)
}
    
    

    @IBAction func backTapped(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        
        let loginScreen: FirstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScreen") as! FirstViewController
        
        present(loginScreen, animated:false, completion: nil)
        
        
    }
}
