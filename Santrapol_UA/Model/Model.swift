//
//  Model.swift
//  Santrapol_UA
//
//  Created by Tamanna Manocha on 2019-02-28.
//  Copyright © 2019 Anshul Manocha. All rights reserved.
//

class Model {
    var cap: Int?
    var loc: String?
    var eventdate: String?
    var eventdate_int: Int?
    var checked: Bool?
    var availableDate: String?
    var slot: String?
    var usercount: Int?
    var eventid: String?
    var driverCap: Int?
    var event_time_start: String?
    var event_time_end: String?
    var is_important_event: Bool?
    var event_date: Int?
    var note: String?

    init(cap: Int?, loc:String?, eventdate:String?, slot:String?, usercount: Int?, driverCap: Int?, note: String?) {
        self.cap = cap
        self.eventdate = eventdate
        self.loc = loc
        self.slot = slot
        self.usercount = usercount
        self.driverCap = driverCap
        self.note = note
    }
    
    init(loc:String?, eventdate:String?, slot:String?, event_time_start: String?, event_time_end: String?, eventid: String?, note: String?) {
        self.loc = loc
        self.eventdate = eventdate
        self.slot = slot
        self.event_time_start = event_time_start
        self.event_time_end = event_time_end
        self.eventid = eventid
        self.note = note
    }
    
    init(loc:String?, eventdate_int:Int?, slot:String?, event_time_start: String?, event_time_end: String?, eventid: String?, note: String?) {
        self.loc = loc
        self.eventdate_int = eventdate_int
        self.slot = slot
        self.event_time_start = event_time_start
        self.event_time_end = event_time_end
        self.eventid = eventid
        self.note = note
    }
    
    init(availableDate: String?, slot:String?) {
        self.availableDate = availableDate
        self.slot = slot
    }
    
    init(checked:Bool?){
     self.checked = checked
    }
    
    init(eventid: String?){
        
        self.eventid = eventid
    }
    
    init(is_important_event: Bool?, event_date:Int?) {
        self.is_important_event = is_important_event
        self.event_date = event_date

    }
    init(note: String?) {
        self.note = note
    }
}


class Names {
    var firstName: String?
    var lastName: String?
    var uid: String?
    var driver: Bool?
    var event_type_user: String?
    var event_start: String?
    var event_end: String?
    var note: String?
    
    init(firstName: String?, lastName: String?, uid: String?, driver: Bool?, event_type_user: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.driver = driver
        self.event_type_user = event_type_user
    }
    
    init(firstName: String?, lastName: String?, uid: String?, driver: Bool?, event_type_user: String?, event_start: String?, event_end: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.driver = driver
        self.event_type_user = event_type_user
        self.event_start = event_start
        self.event_end = event_end
    }
    
}


class EventDisplay {
    var eventdate: String?
    var event_start: String?
    var event_end: String?
    var event_int: Int?
    var event_type: String?
    var cap: Int?
    var note: String?
    
    init(eventdate: String?, event_start: String?, event_end: String?, event_int: Int?, event_type:String?, cap:Int?) {
        self.eventdate = eventdate
        self.event_start = event_start
        self.event_end = event_end
        self.event_int = event_int
        self.event_type = event_type
        self.cap = cap
    }
    
}


class UserInformation {
    var user_first_name: String?
    var user_last_name: String?
    var user_key: String?
    var user_uid: String?
    var email: String?
    var phone_number: String?
    
    init(user_first_name: String?, user_last_name: String?, user_key: String?, user_uid: String?) {
        self.user_first_name = user_first_name
        self.user_last_name = user_last_name
        self.user_key = user_key
        self.user_uid = user_uid
    }
    
    init(email: String?, phone_number: String?) {
        self.email = email
        self.phone_number = phone_number

    }
    
}


class DummyArray {
    var user_id: String?
    
    init(user_id: String?){
        
        
        self.user_id = user_id
    }
    
}
