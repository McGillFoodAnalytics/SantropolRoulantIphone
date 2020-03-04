//
//  AboutUs.swift
//  Santrapol_UA
//
//  Created by Braden Gaerber on 2020-03-04.
//  Copyright © 2020 Anshul Manocha. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoToWebsite(_ sender: Any) {
    
        if let url = URL(string: "https://www.mcfac.org/") {
            UIApplication.shared.open(url)
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

}
