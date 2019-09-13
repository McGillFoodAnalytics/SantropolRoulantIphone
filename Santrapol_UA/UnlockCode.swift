//
//  UnlockCode.swift
//  Santrapol_UA
//
//  Created by Guillaume on 8/29/19.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UnlockCode: UIViewController {

    @IBOutlet weak var alreadyAccount: UIButton!
    
    @IBOutlet weak var codeField: UITextField!
    
    var code: String?
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alreadyAccount.titleLabel?.minimumScaleFactor = 0.5;
        alreadyAccount.titleLabel?.adjustsFontSizeToFitWidth = true;
        
        codeField.frame =  CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width)  * 0.5, height: 36)
        
        
        codeField.setBottomBorder(withColor: UIColor.white)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isTranslucent = true
        
        // Need to load the data from the firebase
        
        Database.database().reference().observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
           self.code = value?["registration_code"] as? String ?? ""
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func enterCodeTapped(_ sender: UIButton) {
        
        if codeField.text ?? ""  == self.code {
            
        codeField.setBottomBorder(withColor: UIColor.white)
            
            // Success, go to the login page
            
            // Performs an action so that this page won't show up again
            
            defaults.set(true, forKey: "codeEntered")
            
            performSegue(withIdentifier: "goToWelcomePage", sender: self)
            
        } else {
            
        codeField.setBottomBorder(withColor: UIColor.red)
            
            let alert = UIAlertController(title: "Oops 💩", message: "The code you entered is incorrect. Please try again.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
           // Show error message and return from the function
            
            return
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func AlreadyHaveAnAccount(_ sender: UIButton) {
        
        performSegue(withIdentifier: "IntroPageToLogin", sender: self)
    }
    
    
}
