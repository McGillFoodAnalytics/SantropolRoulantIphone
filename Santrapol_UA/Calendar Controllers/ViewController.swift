//
//  ViewController.swift
//  UBottomSheet
//
//  Created by ugur on 13.08.2018.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit


class ViewController: UIViewController, BottomSheetDelegate {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var container: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
    }
    

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("does it work?")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BottomSheetViewController{
            vc.bottomSheetDelegate = self
            vc.parentView = container
        }
    }
    
    func updateBottomSheet(frame: CGRect) {
        container.frame = frame
        //        backView.frame = self.view.frame.offsetBy(dx: 0, dy: 15 + container.frame.minY - self.view.frame.height)
        //        backView.backgroundColor = UIColor.black.withAlphaComponent(1 - (frame.minY)/200)
    }

}


