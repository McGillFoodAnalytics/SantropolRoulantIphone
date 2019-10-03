//
//  IntroPage.swift
//  Santrapol_UA
//
//  Created by G Lapierre on 2019-07-30.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Foundation
import FirebaseDatabase
import FirebaseAuth


class IntroPage: UIViewController {
    
    // From previous View Controller
    
    // Created this View Controller

    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        // Allows the background image to overlap the navigation bar
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isTranslucent = true
        
        
        
        // Creates a border for the buttons
      
    createAccountButton.layer.cornerRadius = 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.white.cgColor
        
        logInButton.layer.cornerRadius = 2
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.white.cgColor




        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        
 
        self.performSegue(withIdentifier: "goToPerInfo", sender: self)
    }
    
    
    @IBAction func logInTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToLoginEnv", sender: self)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



class PersonalInformation: UIViewController {
    
    // Created in past View Controllers
    
    // Created this View Controller
    var first_name: String = ""
    var last_name: String = ""
    var dob: String = ""
    var error1: Bool = false
    var error2: Bool = false
    var error3: Bool = false
    
        @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    
    lazy var datePicker: UIDatePicker = {
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        return picker
    } ()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    override func viewDidAppear(_ animated: Bool){
        
        firstNameField.becomeFirstResponder()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

firstNameField.frame.size.width = UIScreen.main.bounds.width - 58
        
        lastNameField.frame.size.width = UIScreen.main.bounds.width - 58
        
        dobField.frame.size.width = UIScreen.main.bounds.width - 58

        firstNameField.setBottomBorder(withColor: UIColor.white)
        lastNameField.setBottomBorder(withColor: UIColor.white)
        dobField.setBottomBorder(withColor: UIColor.white)
        
        dobField.inputView = datePicker

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToContactInfo") {
            let vc = segue.destination as! PersonalContact
            vc.first_name = first_name
            vc.last_name = last_name
            vc.dob = dob
        }
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
        dobField.text = dateFormatter.string(from: sender.date)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        // Get the date of birth in the right format for the Firebase database
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMMM d, yyyy"
        
       let date = dateFormatterGet.date(from: dobField.text!)
        
        let year = Calendar.current.component(.year, from: date ?? Date())
        let month = Calendar.current.component(.month, from: date ?? Date())
        let day = Calendar.current.component(.day, from: date ?? Date())
        
        print("\(year)\(String(format: "%02d", month))\(String(format: "%02d", day))")
        
        // Check the validity of the information
        
        if firstNameField.text! == "" {
            
            firstNameField.frame.size.width = UIScreen.main.bounds.width - 58
            
            firstNameField.setBottomBorder(withColor: UIColor.red)
            error1 = true
            
        } else {
            
            firstNameField.setBottomBorder(withColor: UIColor.white)
            error1 = false
            
        }
        
        
        if lastNameField.text! == "" {
            
            lastNameField.setBottomBorder(withColor: UIColor.red)
            error2 = true
            
        } else {
            
            lastNameField.setBottomBorder(withColor: UIColor.white)
            error2 = false
            
        }
        
        
        if dobField.text! == "" {
            
            dobField.setBottomBorder(withColor: UIColor.red)
            error3 = true
            
        } else {
            
            dobField.setBottomBorder(withColor: UIColor.white)
            error3 = false
            
        }
        
        
        if error1 == true || error2 == true || error3 == true {
            
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            if Locale.current.languageCode == "fr"{
                alert = UIAlertController(title: "Erreur", message: "Certains champs sont manquants ou ont été mal entrés", preferredStyle: .alert)
            }
            else{
                alert = UIAlertController(title: "Error", message: "Some fields are missing or were entered incorrectly", preferredStyle: .alert)
            }
            
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        
        
        
        first_name = firstNameField.text!
        last_name = lastNameField.text!
        dob = "\(year)\(String(format: "%02d", month))\(String(format: "%02d", day))" as String
        
        self.performSegue(withIdentifier: "goToContactInfo", sender: self)

    }
    
    
} // ends the class




class PersonalContact: UIViewController, UITextFieldDelegate  {
    
    // Created in past View Controllers
    var first_name: String = ""
    var last_name: String = ""
    var dob: String = ""
    
    // Created this View Controller
    var email: String = ""
    var phone_number: String = ""
    
    var registeredUsersFull = [UserInformation]()
    
    var error1: Bool = false
    var error2: Bool  = false

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool){
        
        emailField.becomeFirstResponder()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.frame.size.width = UIScreen.main.bounds.width - 58
        
        phoneNumberField.frame.size.width = UIScreen.main.bounds.width - 58
        
        emailField.setBottomBorder(withColor: UIColor.white)
        phoneNumberField.setBottomBorder(withColor: UIColor.white)
        phoneNumberField.delegate = self
        
        Database.database().reference().child("user").observe(.value, with: { (snapshot) in
            
            self.registeredUsersFull.removeAll()
            
            for child in snapshot.children {
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                let email = dict?["email"] as? String
                let phone_number = dict?["phone_number"] as? String
                
                let registeredUser = UserInformation(email: email, phone_number: phone_number)
                
                self.registeredUsersFull.append(registeredUser)
                
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToPerAdress") {
            let vc = segue.destination as! PersonalAddress
            vc.first_name = first_name
            vc.last_name = last_name
            vc.dob = dob
            vc.email = email
            vc.phone_number = phone_number
        }
    }
    
/*    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    } */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneNumberField {
            
            self.phoneNumberField.text = PartialFormatter().formatPartial(self.phoneNumberField.text!)
            return range.location < 14
        } else {
            
        return true
            
        }
        

    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        
        // Verify if the Email and phone number are already in used by another user
        

        

        
        // Check if the email is contained
        
        var email_array = self.registeredUsersFull.map {$0.email}
        if isValidEmail(testStr: emailField.text!) == false {
            
            self.error1 = true
            self.emailField.setBottomBorder(withColor: UIColor.red)
            
        } else if email_array.contains(self.emailField.text!) {
            
            self.error1 = true
            self.emailField.setBottomBorder(withColor: UIColor.red)
            
        } else {
            
            self.error1 = false
            self.emailField.setBottomBorder(withColor: UIColor.white)
            
        }

            // Check if the email is in the right format and/or already in use
         /*   Auth.auth().fetchProviders(forEmail: emailField.text!, completion: {
                (providers, error) in
                
                if let error = error {
                    self.error1 = true
                    self.emailField.setBottomBorder(withColor: UIColor.red)
                } else if email_array.contains(self.emailField.text!) {

                } else {
                    self.error1 = false
                    self.emailField.setBottomBorder(withColor: UIColor.white)
                    
                }
            }) */
        
        print(isValidEmail(testStr: emailField.text!))
        // Check if the phone number is contained
        
        var phone_number_array = self.registeredUsersFull.map {$0.phone_number}
        
        if phone_number_array.contains(phoneNumberField.text!.digitsOnly()) {
            
            error2 = true
            self.phoneNumberField.setBottomBorder(withColor: UIColor.red)
            
        } else if phoneNumberField.text!.digitsOnly().count != 10 {
            
            error2 = true
            self.phoneNumberField.setBottomBorder(withColor: UIColor.red)
            
        } else {
            
            error2 = false
            self.phoneNumberField.setBottomBorder(withColor: UIColor.white)
            
        }
        
        
        
        if error1 == true || error2 == true {
            
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            if Locale.current.languageCode == "fr"{
                alert = UIAlertController(title: "Erreur", message: "Certains champs ont été mal saisis ou sont déjà utilisés", preferredStyle: .alert)
            }
            else{
                alert = UIAlertController(title: "Error", message: "Some fields were entered incorrectly or are already in use", preferredStyle: .alert)
            }
            
            
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        

  
        
        phone_number = phoneNumberField.text!.digitsOnly()
        email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        performSegue(withIdentifier: "goToPerAdress", sender: self)
        
            
    }
        
        

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    

} // Ends the class


class PersonalAddress: UIViewController, UITextFieldDelegate {
    
    // Created in past View Controllers
    var first_name: String = ""
    var last_name: String = ""
    var dob: String = ""
    var email: String = ""
    var phone_number: String = ""
    
    // Created this View Controller
    var address_city: String = ""
    var address_number: Int = 0
    var address_postal_code: String = ""
    var address_street: String = ""
    
    var error1: Bool = false
    var error2: Bool  = false
    var error3: Bool = false

    

    
    @IBOutlet weak var addressLbl: UITextField!
    
    
    @IBOutlet weak var cityLbl: UITextField!
  
    
    @IBOutlet weak var postalCodeLbl: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool){
        
        addressLbl.becomeFirstResponder()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLbl.frame.size.width = UIScreen.main.bounds.width - 58
        
        cityLbl.frame.size.width = UIScreen.main.bounds.width - 58
        
        postalCodeLbl.frame.size.width = UIScreen.main.bounds.width - 58
        
        addressLbl.setBottomBorder(withColor: UIColor.white)
        cityLbl.setBottomBorder(withColor: UIColor.white)
        postalCodeLbl.setBottomBorder(withColor: UIColor.white)
        postalCodeLbl.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToPerPassword") {
            let vc = segue.destination as! PersonalPassword
            vc.first_name = first_name
            vc.last_name = last_name
            vc.dob = dob
            vc.email = email
            vc.phone_number = phone_number
            vc.address_city = address_city
            vc.address_number = address_number
            vc.address_postal_code = address_postal_code
            vc.address_street = address_street
        }
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        
        if addressLbl.text! == "" {
            
            addressLbl.setBottomBorder(withColor: UIColor.red)
            error1 = true
            
        } else {
            
            addressLbl.setBottomBorder(withColor: UIColor.white)
            error1 = false
            
        }
        
        
        if cityLbl.text! == "" {
            
            cityLbl.setBottomBorder(withColor: UIColor.red)
            error2 = true
            
        } else {
            
            cityLbl.setBottomBorder(withColor: UIColor.white)
            error2 = false
            
        }
        
        
        if String(postalCodeLbl.text!.filter { !" \n\t\r".contains($0) }).count != 6 {
            
            postalCodeLbl.setBottomBorder(withColor: UIColor.red)
            error3 = true
            
        } else {
            
            postalCodeLbl.setBottomBorder(withColor: UIColor.white)
            error3 = false
            
        }
        
        
        if error1 == true || error2 == true || error3 == true {
            
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            if Locale.current.languageCode == "fr"{
                alert = UIAlertController(title: "Erreur", message: "Certains champs sont manquants ou ont été mal entrés", preferredStyle: .alert)
            }
            else{
                alert = UIAlertController(title: "Error", message: "Some fields are missing or were entered incorrectly", preferredStyle: .alert)
            }
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
        // This captures the Street Number
        print(addressLbl.text!.digitsOnly())
        
        // Street Name
        print(addressLbl.text!.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: .whitespacesAndNewlines))
        
        // City
        print(cityLbl.text!)
        
        // Postal Code
        print(String(postalCodeLbl.text!.filter { !" \n\t\r".contains($0) }))
        
        address_city = cityLbl.text!
        address_number = Int(addressLbl.text!.digitsOnly()) ?? 0
        address_postal_code = String(postalCodeLbl.text!.filter { !" \n\t\r".contains($0) })
        address_street = addressLbl.text!.components(separatedBy: CharacterSet.decimalDigits).joined().trimmingCharacters(in: NSCharacterSet(charactersIn: ",") as CharacterSet).trimmingCharacters(in: .whitespacesAndNewlines)
        
        performSegue(withIdentifier: "goToPerPassword", sender: self)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == postalCodeLbl {
            
            return range.location < 7
            
        } else {
            
            return true
            
        }
        
        
    }
    
    
}


class PersonalPassword: UIViewController, UITextFieldDelegate {
    
    // Created in past View Controllers
    var first_name: String?
    var last_name: String = ""
    var dob: String = ""
    var email: String?
    var phone_number: String = ""
    var address_city: String = ""
    var address_number: Int = 0
    var address_postal_code: String = ""
    var address_street: String = ""
    
    // Created this View Controller
    var password: String = ""
    var uid: String = ""
    var key: String = ""
    var signup_date: String = Date().string(format: "yy/MM/dd")
    
    
    @IBOutlet weak var passwordLbl: UITextField!
  
    
    @IBOutlet weak var confirmPasswordLbl: UITextField!
    
    @IBOutlet weak var showPass: UIButton!
    
    @IBOutlet weak var showConfirmPass: UIButton!
    
    
  //  @IBOutlet weak var showPass: UIButton!
    
  //  @IBOutlet weak var showConfirmPass: UIButton!
    
    override func viewDidAppear(_ animated: Bool){
        
        passwordLbl.becomeFirstResponder()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = String(last_name.lowercased().prefix(2)) + phone_number
        
        passwordLbl.frame.size.width = UIScreen.main.bounds.width - 58
        
        confirmPasswordLbl.frame.size.width = UIScreen.main.bounds.width - 58
        
        passwordLbl.setBottomBorder(withColor: UIColor.white)
        confirmPasswordLbl.setBottomBorder(withColor: UIColor.white)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToFinish") {
            let vc = segue.destination as! AccountSetUp
            vc.uid = uid
        }
    }
    

    
    @IBAction func togglePass(_ sender: UIButton) {
         
        if passwordLbl.isSecureTextEntry == false {
            
            // The button is showing text and now we want to hide it
            passwordLbl.isSecureTextEntry = true
            UIView.performWithoutAnimation {
                showPass.setTitle("Show", for: .normal)
                showPass.layoutIfNeeded()
            }

        } else {
            
            // The password is hidden and now we want to display it
            passwordLbl.isSecureTextEntry = false
            
            UIView.performWithoutAnimation {
                showPass.setTitle("Hide", for: .normal)
                showPass.layoutIfNeeded()
            }
            
        }
    }
    

    @IBAction func toggleConfirmPass(_ sender: UIButton) {
        
        if confirmPasswordLbl.isSecureTextEntry == false {
            
            // The button is showing text and now we want to hide it
            confirmPasswordLbl.isSecureTextEntry = true
            UIView.performWithoutAnimation {
                showConfirmPass.setTitle("Show", for: .normal)
                showConfirmPass.layoutIfNeeded()
            }

        } else {
            
            // The password is hidden and now we want to display it
            confirmPasswordLbl.isSecureTextEntry = false
            UIView.performWithoutAnimation {
                showConfirmPass.setTitle("Hide", for: .normal)
                showConfirmPass.layoutIfNeeded()
            }
            
            
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        
       
        
        if passwordLbl.text! == "" {
            
            passwordLbl.setBottomBorder(withColor: UIColor.red)
            confirmPasswordLbl.setBottomBorder(withColor: UIColor.white)
            
            showAlert(message: "The password field cannot be left empty!")
            return
            
            
        }
        
        else if passwordLbl.text! != confirmPasswordLbl.text! {
            
            passwordLbl.setBottomBorder(withColor: UIColor.red)
            confirmPasswordLbl.setBottomBorder(withColor: UIColor.red)
            
            showAlert(message: "Passwords do not match!")
            return
            
            
        } else {
            
            passwordLbl.setBottomBorder(withColor: UIColor.white)
            confirmPasswordLbl.setBottomBorder(withColor: UIColor.white)
            
        }
        
     /*   // Created in past View Controllers
        var first_name: String = ""
        var last_name: String = ""
        var dob: String = ""
        var email: String = ""
        var phone_number: String = ""
        var address_city: String = ""
        var address_number: Int = 0
        var address_postal_code: String = ""
        var address_street: String = ""
        
        // Created this View Controller
        var password: String = ""
        var uid: String = ""
        var key: String = ""
        var signup_date: String = Date().string(format: "yy/MM/dd") */
        
        addUsers()
        
        password = passwordLbl.text!
        

        
        
        
        performSegue(withIdentifier: "goToFinish", sender: self)
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
    
    func addUsers() {
        //useref = Database.database().reference().child("Users")
        //let key = useref.child(user.uid).key
        
        if let email = email,
            let pass = passwordLbl.text, let Firstname = first_name
        { Auth.auth().createUser(withEmail: email, password: pass)  { (user, error) in
            
            //Check error and show error message

            let key = Auth.auth().currentUser!.uid

            print(key)
            
            let dictionary: NSDictionary = [
                "first_name" : self.first_name,
                "last_name" : self.last_name,
                "email": self.email,
                "dob": self.dob,
                "phone_number": self.phone_number,
                "address_city": self.address_city,
                "address_number": self.address_number,
                "address_postal_code": self.address_postal_code,
                "address_street": self.address_street,
                "key": key,
                "signup_date": self.signup_date,
                "no_show": 0
                
                // Write more information about the user in the future
                
            ]
            
            // Insert the information in the database
            Database.database().reference().child("user").child(self.uid).setValue(dictionary)
            
            
            
            }
            
            
        }
    }
    
} // closes the class


class AccountSetUp: UIViewController, UITextFieldDelegate {
    
    var uid: String = ""
    
    
    @IBOutlet weak var userNameField: UITextField!
    
    override func viewDidLoad() {
        
        userNameField.frame.size.width = UIScreen.main.bounds.width - 58
        userNameField.setBottomBorder(withColor: UIColor.white)
        userNameField.placeholder = uid
        
        userNameField.isUserInteractionEnabled = false
        
        super.viewDidLoad()
        
    
    
}
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
        let viewControllers = self.navigationController!.viewControllers
        for var aViewController in viewControllers
        {
            if aViewController is IntroPage
            {
                let aVC = aViewController as! IntroPage
                
                _ = self.navigationController?.popToViewController(aVC, animated: true)
            }
        }
        
    }
}


extension UITextField
{
    func setBottomBorder(withColor color: UIColor)
    {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}

extension String {
    
    var length : Int {
        return self.characters.count
    }
    
    func digitsOnly() -> String{
        let stringArray = self.components(
            separatedBy: NSCharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        
        return newString
    }
    
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}




