//
//  AboutUs.swift
//  Santrapol_UA
//
//  Created by Braden Gaerber on 2020-03-04.
//  Copyright © 2020 Anshul Manocha. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {

    // height constraint of first view
    @IBOutlet weak var FirstViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ContainerStackTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sets the height of first view equal to height of phone screen
        FirstViewHeight.constant = UIScreen.main.bounds.height
        
        let xBarHeight = (self.navigationController?.navigationBar.frame.size.height ?? 0.0) + (self.navigationController?.navigationBar.frame.origin.y ?? 0.0)
        
        ContainerStackTop.constant = xBarHeight
        
    }
    
    // takes user to website
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
