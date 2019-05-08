//
//  UrbanAgriculture.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-17.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit

class UrbanAgriculture: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func RRTapped(_ sender: UIButton) {
    
         let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "RoulantRooftop"
        self.present(DisplayVC, animated: true, completion: nil)
    }
    
    @IBAction func TRTapped(_ sender: Any) {
         let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "Le Terrases Roy"
          self.present(DisplayVC, animated: true, completion: nil)
    }
    
   
    @IBAction func SFTapped(_ sender: UIButton) {
        let DisplayVC: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayVC") as! ViewController
        DisplayVC.location = "Senneville"
        self.present(DisplayVC, animated: true, completion: nil)
    }
    
    /*var location:String = "Senneville"
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var DesViewController : ViewController = segue.destination as! ViewController
        DesViewController.location = location
        print("DestinationViewController", DesViewController.location)
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}
