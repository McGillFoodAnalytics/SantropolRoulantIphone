//
//  AppDelegate.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-02-06.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseUI
import FirebaseAuth
import IQKeyboardManagerSwift




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
                // forces light mode
                
            window?.overrideUserInterfaceStyle = .light
        }
        // Override point for customization after application launch.

      UINavigationBar.appearance().barTintColor = UIColor.white
      UINavigationBar.appearance().tintColor = UIColor(red: 104.0/255.0, green: 23.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 104.0/255.0, green: 23.0/255.0, blue: 104.0/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20)!]
        
        
        // loads external libraries
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = false

        // retrieves user from firebase
        self.storyboard =  UIStoryboard(name: "Main", bundle: Bundle.main)
        let currentUser = Auth.auth().currentUser
        
        // if user exist take them to home page
        // NOTE: could be consolidated...
      
        /*
        if currentUser != nil {
            defaultDirect(location: "HomePage")
        } else if !defaults.bool(forKey: "codeEntered") {
            defaultDirect(location: "UnlockCode")
        } else {
            defaultDirect(location: "IntroPage")
        }
        */
        
        
        
        if currentUser != nil {
          /*  self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") */
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePage") as! HomePage
            let navigationController = UINavigationController(rootViewController: nextViewController)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
            
        } else if !defaults.bool(forKey: "codeEntered") {
            
            // Access code has not been entered, present the page to enter the code
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UnlockCode") as! UnlockCode
            let navigationController = UINavigationController(rootViewController: nextViewController)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
    
        } else {
            
            // Access code has already been entered, present the login environment
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IntroPage") as! IntroPage
            let navigationController = UINavigationController(rootViewController: nextViewController)
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
            
        }
            
        /*window = UIWindow()
        window?.makeKeyAndVisible()
        let navController = UINavigationController(rootViewController: EventSection())
        window?.rootViewController = navController*/
        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    
    
    //------------------------DEFAULT FUNCTIONS------------------------------
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIViewController {
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

