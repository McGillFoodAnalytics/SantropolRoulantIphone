//
//  Model.swift
//  Santrapol_UA
//
//  Created by Tamanna Manocha on 2019-02-28.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

class Model {
    var loc: String?
    var eventdate: String?
    var checked: Bool?
    var availableDate: String?
    var slot: String?
    init(loc:String?, eventdate:String?, slot:String?) {
        self.eventdate = eventdate
        self.loc = loc
        self.slot = slot
    }
    
    init(availableDate: String?, slot:String?) {
        self.availableDate = availableDate
        self.slot = slot
    }
    init(checked:Bool?){
     self.checked = checked
    }
}
