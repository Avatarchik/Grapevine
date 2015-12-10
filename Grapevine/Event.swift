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
    var eventPhoto: UIImage
    
    init() {
        objectID = ""
        eventName = ""
        hostedBy = ""
        start = NSDate()
        end = NSDate()
        location = ""
        description = ""
        eventPhoto = UIImage()
    }
    
    func convertEventDateFormatter(date: NSDate) -> String {
        //   CURRENT: 2015-12-07 03:40:00 +0000
        // CONVERTED: Dec 7
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d"
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    func convertEventTimeFormatter(date: NSDate) -> String {
        //   CURRENT: 2015-12-07 03:40:00 +0000
        // CONVERTED: 3:40am
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:ma"
        let timeString = formatter.stringFromDate(date).lowercaseString
        return timeString
    }
}