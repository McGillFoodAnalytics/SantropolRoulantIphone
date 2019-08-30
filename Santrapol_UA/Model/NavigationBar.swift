//
//  NavigationBar.swift
//  Santrapol_UA
//
//  Created by Tamanna Manocha on 2019-03-27.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit

class NavigationBar: UIViewController {

    static var app: NavigationBar = {
        return NavigationBar()
        
    }()
    
    var Home: UIImage? = UIImage(named:"Screen Shot 2019-01-27 at 1.05.03 PM")?.withRenderingMode(.alwaysOriginal)
    var Profile: UIImage? = UIImage(named: "icons8-customer-filled-50-2")?.withRenderingMode(.alwaysOriginal)
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    @objc func HomeButtonTapped(sender: UIBarButtonItem) {
       let Home: HomePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as! HomePage
        
      topMostController().present(Home, animated: true, completion: nil)
    
    }
    
    @objc func ProfileButtonTapped(sender: UIBarButtonItem)  {
        let Profile: ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        
        topMostController().present(Profile, animated: true, completion: nil)
    }
    
    public func setUpNavigationBarItems(PageHeader: UINavigationItem, location: String)
    {
        
        let HomeButton = UIButton(type: .system)
        
        HomeButton.setImage( Home, for: .normal)
        PageHeader.title = location
        
        HomeButton.addTarget(self, action: #selector(self.HomeButtonTapped), for: .touchUpInside)
        PageHeader.rightBarButtonItem = UIBarButtonItem(customView: HomeButton)
        let ProfileButton = UIButton(type: .system)
        ProfileButton.setImage(Profile, for: .normal)
        ProfileButton.addTarget(self, action: #selector(ProfileButtonTapped), for: .touchUpInside)
        //PageHeader.leftBarButtonItem = UIBarButtonItem(customView: ProfileButton)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
