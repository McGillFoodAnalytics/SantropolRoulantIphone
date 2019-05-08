//
//  VolunteerSignup.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-19.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit

class VolunteerSignup: UIViewController {

    //@IBOutlet weak var PageHeader: UINavigationBar!
    @IBOutlet weak var PageHeader: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationBar.app.setUpNavigationBarItems(PageHeader: PageHeader, location: "SignUp")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func MealDelTapped(_ sender: UIButton) {
        let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "MealDelivery"
        self.present(DisplayVC, animated: true, completion: nil)
    }
    
    @IBAction func FoodPrepTapped(_ sender: UIButton) {
        let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "FoodPreparation"
        self.present(DisplayVC, animated: true, completion: nil)
    }
    
    @IBAction func Collectives(_ sender: UIButton) {
        let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "Collectives"
        self.present(DisplayVC, animated: true, completion: nil)
    }
    
    @IBAction func FoodPreservation(_ sender: UIButton) {
        let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "FoodPreservation"
        self.present(DisplayVC, animated: true, completion: nil)
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
