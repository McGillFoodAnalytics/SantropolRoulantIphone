//
//  EventSection.swift
//  Santrapol_UA
//
//  Created by Anshul Manocha on 2019-02-26.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventSection: UITableViewCell {

    var eventref = Database.database().reference().child("volunteerAct")
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var Checked: UIButton!
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var Slot: UILabel!
    
    
    
}

class AvailableEvents: UITableViewCell{
    
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var cap: UILabel!
    
}
