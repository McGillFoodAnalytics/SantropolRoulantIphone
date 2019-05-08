//
//  ProfileViewController.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-03-04.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var PageHeader: UINavigationItem!
    let userid = Auth.auth().currentUser!.uid
    
    
    @IBOutlet weak var BarCode: UIImageView!
    @IBAction func EditProfileTapped(_ sender: Any) {
    }
    
    @IBAction func AttendanceTapped(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "goToHomefromPr", sender: self)
    } 
    
    //
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         NavigationBar.app.setUpNavigationBarItems(PageHeader: PageHeader, location: "Attendance")
         BarCode.image = generateBarcode(from: userid)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    
    
    

}
