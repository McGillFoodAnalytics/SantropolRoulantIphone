//
//  ViewController.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
    case dark
}

class CalenderVC: UIViewController, CalenderDelegate, BottomSheetDelegate  {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var container: UIView!
    var stringy: String? = "fuck off lol"
   
    var containerViewController: BottomSheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stringy = "this is a test"
        
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        
        
        self.title = "Calender"
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Style.bgColor
        
        
        view.addSubview(calenderView)
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        self.view.sendSubview(toBack: calenderView)
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightBarBtnAction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BottomSheetViewController{
            vc.bottomSheetDelegate = self
            vc.parentView = container
            
        }
        
        if segue.identifier == "test" {
            containerViewController = segue.destination as? BottomSheetViewController
            containerViewController?.test = self.stringy ?? "fuck it did not work"
            
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("does it work?")
    }
    
    func updateBottomSheet(frame: CGRect) {
        container.frame = frame
        //        backView.frame = self.view.frame.offsetBy(dx: 0, dy: 15 + container.frame.minY - self.view.frame.height)
        //        backView.backgroundColor = UIColor.black.withAlphaComponent(1 - (frame.minY)/200)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        print(123)
    }
    
    @objc func dismissVC(sender: UIBarButtonItem) {
       self.dismiss(animated: true, completion: nil)
    }

    
    lazy var  calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
    
    func didTapDate(date: String, available: Bool) {
        if available == true {
            print(date)
            stringy = String(date)
            print(stringy)
            print(self.containerViewController?.test)
            containerViewController?.test = self.stringy ?? "it did not work"
            print(self.containerViewController?.test)
          //  containerViewController?.viewDidLoad()
            containerViewController?.viewWillAppear(false)
        } else {
            showAlert()
        }
    }
    
  
   
    fileprivate func showAlert(){
        let alert = UIAlertController(title: "Unavailable", message: "This slot is already booked.\nPlease choose another date.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

