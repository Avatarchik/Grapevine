//
//  Event.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/6/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import Foundation
import Parse

class Event {
    var objectID: String
    var eventName: String
    var hostedBy: String
    var start: NSDate
    var end: NSDate
    var location: String
    var description: String
//    var eventPhoto: PFFile
    
    init() {
        objectID = ""
        eventName = ""
        hostedBy = ""
        start = NSDate()
        end = NSDate()
        location = ""
        description = ""
//        eventPhoto = PFFile
    }
}