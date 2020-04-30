//
//  HomePage.swift
//  Santrapol_UA
//
//  Created by G Lapierre on 2019-07-04.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomePage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var screenSize: CGRect!

    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var PageHeader: UINavigationItem!
    
    @IBOutlet weak var NameLbl: UILabel!
    //Create array for labels and images
    
    var options = ["Volunteer", "My schedule", "Profile", "Contact us"]

    var subtitle = ["Do good & feel good", "Check your schedule", "Update information", "Inquiries and more"]
    let optionsgeneral = ["1", "2", "3", "4"]
    
    let userid = Auth.auth().currentUser!.uid
    var user_first_name: String?
    
    let optionsImages: [UIImage] = [
    
        UIImage(named: "volunteericon")!,
        UIImage(named: "scheduleicon")!,
        UIImage(named: "profileicon")!,
        UIImage(named: "contacticon")!,

    ]

    override func viewWillAppear(_ animated: Bool) {
        
        Database.database().reference().child("user").queryOrdered(byChild: "key").queryEqual(toValue: userid).observe(.value, with: { (snapshot) in
            
            for child in snapshot.children {
                
                let childSnapshot = child as? DataSnapshot
                let dict = childSnapshot?.value as? [String:Any]
                
                
                // Fetch the user information and communicate to the global variable
                
                self.user_first_name = dict?["first_name"] as? String
                
                if Locale.current.languageCode == "fr"{
                    self.NameLbl.text = "Bonjour, \(self.user_first_name ?? "")!"
                }
                else{
                    self.NameLbl.text = "Hello, \(self.user_first_name ?? "")!"
                }
            }
        })
    }
    
    
    
    override func viewDidLoad() {
        
        if Locale.current.languageCode == "fr"{
            options = ["Bénévolat", "Mon horaire", "Profil", "Nous joindre"]
            
            subtitle = ["Faites le bien", "Voir votre horaire", "Vos informations", "Nos informations"]
        }
        
        navigationController?.navigationBar.isTranslucent = true

        super.viewDidLoad()
        
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isTranslucent = true
        
        
        
        self.navigationItem.title = ""
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        screenSize = UIScreen.main.bounds

        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        
        let layout = self.CollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (screenSize.width - 20)/2, height: ((screenSize.height/1.6) - 20)/2)
        

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollection", for: indexPath) as! CollectionViewCell
        
        cell.OptionLabel.text = options[indexPath.item]
        cell.OptionSubtitle.text = subtitle[indexPath.item]
        
        cell.OptionImageView.image = optionsImages[indexPath.item]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dummy = optionsgeneral[indexPath.item]
     
        if dummy == "1" {
            
            performSegue(withIdentifier: "goToSignUp", sender: self)
        } else if dummy == "2" {
            
            performSegue(withIdentifier: "goToSchedule", sender: self)
            
        } else if dummy == "3" {
            
        performSegue(withIdentifier: "goToProfileHome", sender: self)
            
        } else if dummy == "4" {
            
        performSegue(withIdentifier: "goToContact", sender: self)
        }
        
        
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
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
