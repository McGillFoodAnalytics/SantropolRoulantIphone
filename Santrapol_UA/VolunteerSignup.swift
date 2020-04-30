//
//  VolunteerSignup.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-19.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit


class VolunteerSignup: UIViewController {
    
    // Outlet for the Views
    @IBOutlet weak var mainViewKitchen: UIView!
    @IBOutlet weak var subViewKitchen: UIView!
    
    @IBOutlet weak var mainViewDelivery: UIView!
    @IBOutlet weak var subViewDelivery: UIView!
    
    // Outlet for the bottom information
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    // Bool values to go to the next page
    
    var kitchenSelected: Bool = false
    var DeliverySelected: Bool = false
    
    var data: String!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToCalendar") {
            let vc = segue.destination as! CalenderVC
            vc.typecontroller = data
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
        
        self.navigationItem.title = ""
        
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "home")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        // Default values
        typeLbl.text = " "
        typeImage.image = nil
        descriptionLbl.text = " "
        
        
        self.mainViewKitchen.layer.borderWidth = 2
        self.mainViewDelivery.layer.borderWidth = 2
        self.mainViewKitchen.layer.borderColor = UIColor.clear.cgColor
        self.mainViewDelivery.layer.borderColor = UIColor.clear.cgColor
        
        self.subViewKitchen.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewDelivery.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        

        
    }
    
    @IBAction func buttonDeliveryTapped(_ sender: UIButton) {
        
        
        self.mainViewKitchen.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewDelivery.layer.borderColor = UIColor(red:53/255, green:127/255, blue:50/255, alpha: 1).cgColor
        
        self.subViewKitchen.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewDelivery.backgroundColor = UIColor(red:208/255, green:127/255, blue:206/255, alpha: 1)
        
        // Change the type description
    
        
        if Locale.current.languageCode == "fr"{
            descriptionLbl.text = "Aidez à livrer un repas chaud tout en souriant pour rendre la journée de nos clients meilleure!"
            typeLbl.text = "LIVRAISON"
        }
        else{
          
            descriptionLbl.text = "Help deliver a warm meal and a smiling greeting that can help make our client's day!"
            typeLbl.text = "MEAL DELIVERY"
        }
        
        
        typeImage.image = UIImage(named: "DeliveryPicture")
        
    
        DeliverySelected = true
        kitchenSelected = false
    }
    
   
    @IBAction func buttonKitchenTapped(_ sender: UIButton) {
        
        self.mainViewDelivery.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewKitchen.layer.borderColor = UIColor(red:53/255, green:127/255, blue:50/255, alpha: 1).cgColor
        
        self.subViewDelivery.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewKitchen.backgroundColor = UIColor(red:208/255, green:127/255, blue:206/255, alpha: 1)
        
        
        if Locale.current.languageCode == "fr"{
            
            descriptionLbl.text = "Travaillez avec un chef pour réunir tous les éléments nécessaires à la préparation du repas de la journée!"
            typeLbl.text = "CUISINE"
        }
        else{
            descriptionLbl.text = "Work with a chef to bring together all of the elements to prepare the meal of the day!"
            typeLbl.text = "KITCHEN"
        }
             
        typeImage.image = UIImage(named: "KitchenPicture")
        
        DeliverySelected = false
        kitchenSelected = true
        
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        
        if DeliverySelected == true {
        
            if Locale.current.languageCode == "fr"{
                data = "Livraison"
            }
            else{
                data = "Meal Delivery"
            }
          
            performSegue(withIdentifier: "goToDeliveryChoice", sender: self)
            
            
        } else if kitchenSelected == true {
            
            performSegue(withIdentifier: "goToKitchenChoice", sender: self)
            
            
            
        } else {
            
            // Display an alert
            var alert = UIAlertController(title: "", message: "Please select a type of activity!", preferredStyle: .alert)
            
            if Locale.current.languageCode == "fr"{
                    alert = UIAlertController(title: "", message: "Veuillez sélectionner un type d'activité!", preferredStyle: .alert)
                }
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
 }


class KitchenChoice: UIViewController {
    
    
    @IBOutlet weak var mainViewMorning: UIView!
    @IBOutlet weak var subViewMorning: UIView!
    @IBOutlet weak var mainViewAfternoon: UIView!
    @IBOutlet weak var subViewAfternoon: UIView!
    
    var data: String!
    
    var afternoonSelected: Bool = false
    var morningSelected: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToCalendarFromKitchen") {
            let vc = segue.destination as! CalenderVC
            vc.typecontroller = data
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
        
        self.navigationItem.title = ""
        
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "home")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        self.mainViewMorning.layer.borderWidth = 2
        self.mainViewAfternoon.layer.borderWidth = 2
        self.mainViewMorning.layer.borderColor = UIColor.clear.cgColor
        self.mainViewAfternoon.layer.borderColor = UIColor.clear.cgColor
        
        self.subViewMorning.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewAfternoon.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
    
    
}
  
    
    @IBAction func morningTapped(_ sender: UIButton) {
        
        self.mainViewAfternoon.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewMorning.layer.borderColor = UIColor(red:53/255, green:127/255, blue:50/255, alpha: 1).cgColor
        
        self.subViewAfternoon.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewMorning.backgroundColor = UIColor(red:208/255, green:127/255, blue:206/255, alpha: 1)
        
                  data = "Kitchen AM"
        
        morningSelected = true
        afternoonSelected = false
        
        performSegue(withIdentifier: "goToCalendarFromKitchen", sender: self)
    }
    
    @IBAction func afternoonTapped(_ sender: UIButton) {
        
        self.mainViewMorning.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewAfternoon.layer.borderColor = UIColor(red:53/255, green:127/255, blue:50/255, alpha: 1).cgColor
        
        self.subViewMorning.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewAfternoon.backgroundColor = UIColor(red:208/255, green:127/255, blue:206/255, alpha: 1)
        

                   data = "Kitchen PM"

        
        morningSelected = false
        afternoonSelected = true
        
        performSegue(withIdentifier: "goToCalendarFromKitchen", sender: self)
    }

}


class DeliveryChoice: UIViewController {
    
    
    @IBOutlet weak var mainViewDriver: UIView!
    @IBOutlet weak var subViewDriver: UIView!
    @IBOutlet weak var mainViewNonDriver: UIView!
    @IBOutlet weak var subViewNonDriver: UIView!

    @IBOutlet weak var informationDriverLbl: UILabel!
    
    var data: String!
    
    var nonDriverSelected: Bool = false
    var driverSelected: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToCalendarFromDelivery") {
            let vc = segue.destination as! CalenderVC
            vc.typecontroller = data
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
        
        informationDriverLbl.text = " "
        self.navigationItem.title = ""
        
        // Sets up the right button of the navigation bar --- Can change the image at any time
        var image = UIImage(named: "home")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let editButton   = UIBarButtonItem(image: image,  style: .plain, target: self, action: #selector(didTapEditButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        self.mainViewDriver.layer.borderWidth = 2
        
        self.mainViewNonDriver.layer.borderWidth = 2
        
        self.mainViewDriver.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewNonDriver.layer.borderColor = UIColor.clear.cgColor
        
        self.subViewDriver.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewNonDriver.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        
        
    }
    
    
    @IBAction func morningTapped(_ sender: UIButton) {
        
        self.mainViewNonDriver.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewDriver.layer.borderColor = UIColor(red:53/255, green:127/255, blue:50/255, alpha: 1).cgColor
        
        self.subViewNonDriver.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewDriver.backgroundColor = UIColor(red:208/255, green:127/255, blue:206/255, alpha: 1)
        
        if Locale.current.languageCode == "en"{
            informationDriverLbl.text = "Pick this option if you intend to serve the route Notre-Dame-de-Grâce (NDG) or Côte-des-Neiges (CDN)."
        }
        else{
            informationDriverLbl.text = "Choisissez cette option si vous souhaitez desservir la route Notre-Dame-de-Grâce (NDG) ou Côte-des-Neiges (CDN)."
        }
        
        driverSelected = true
        nonDriverSelected = false
    }
    
    @IBAction func afternoonTapped(_ sender: UIButton) {
        
        self.mainViewDriver.layer.borderColor = UIColor.clear.cgColor
        
        self.mainViewNonDriver.layer.borderColor = UIColor(red:53/255, green:127/255, blue:50/255, alpha: 1).cgColor
        
        self.subViewDriver.backgroundColor = UIColor(red:221/255, green:171/255, blue:220/255, alpha: 1)
        
        self.subViewNonDriver.backgroundColor = UIColor(red:208/255, green:127/255, blue:206/255, alpha: 1)
        
        if Locale.current.languageCode == "fr"{
            informationDriverLbl.text = "Choisissez cette option si vous souhaitez desservir l’itinéraire Outremont, Mile End, Centre Sud, McGill, Centre-ville ou Westmount."
        }
        else{
             informationDriverLbl.text = "Pick this option if you want to serve the route Outremont, Mile End, Centre Sud, McGill, Downtown or Westmount."
        }

        driverSelected = false
        nonDriverSelected = true
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        
        if driverSelected == true {
            
                data = "Meal Delivery Driver"
 
          
            performSegue(withIdentifier: "goToCalendarFromDelivery", sender: self)
            
            
        } else if nonDriverSelected == true {
            
 
                data = "Meal Delivery Non-Driver"
           
            performSegue(withIdentifier: "goToCalendarFromDelivery", sender: self)
            
            
        } else {
            
            // Display an alert
            var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            if Locale.current.languageCode == "fr"{
                alert = UIAlertController(title: "", message: "S'il vous plaît sélectionnez une préférence de temps!", preferredStyle: .alert)
            }
            else{
                alert = UIAlertController(title: "", message: "Please select a time preference!", preferredStyle: .alert)
            }
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
