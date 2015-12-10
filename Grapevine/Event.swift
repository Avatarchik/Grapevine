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
    var objectID: String?
    var eventName: String?
    var hostedBy: String?
    var start: NSDate?
    var end: NSDate?
    var location: String?
    var eventDescription: String?
    var eventPhoto: UIImage?
    
    init() {
        objectID = ""
        eventName = ""
        hostedBy = ""
        start = NSDate()
        end = NSDate()
        location = ""
        eventDescription = ""
        eventPhoto = UIImage()
    }

//    var objectID: String?
//    var eventName: String?
//    var hostedBy: String?
//    var start: NSDate?
//    var end: NSDate?
//    var location: String?
//    var eventDescription: String?
//    var eventPhoto: UIImage?
//    
//    override init() {
//        super.init()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        self.objectID = aDecoder.decodeObjectForKey("ObjectID") as? String
//        self.eventName = aDecoder.decodeObjectForKey("EventName") as? String
//        self.hostedBy = aDecoder.decodeObjectForKey("HostedBy") as? String
//        self.start = aDecoder.decodeObjectForKey("StartTime") as? NSDate
//        self.end = aDecoder.decodeObjectForKey("EndTime") as? NSDate
//        self.location = aDecoder.decodeObjectForKey("Location") as? String
//        self.eventDescription = aDecoder.decodeObjectForKey("EventDescription") as? String
//        self.eventPhoto = aDecoder.decodeObjectForKey("EventPhotoData") as? UIImage
//        super.init()
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(objectID, forKey: "ObjectID")
//        aCoder.encodeObject(eventName, forKey: "EventName")
//        aCoder.encodeObject(hostedBy, forKey: "HostedBy")
//        aCoder.encodeObject(start, forKey: "StartTime")
//        aCoder.encodeObject(end, forKey: "EndTime")
//        aCoder.encodeObject(location, forKey: "Location")
//        aCoder.encodeObject(eventDescription, forKey: "EventDescription")
//        aCoder.encodeObject(eventPhoto, forKey: "EventPhotoData")
//    }
    
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
        formatter.dateFormat = "h:mma"
        let timeString = formatter.stringFromDate(date).lowercaseString
        return timeString
    }
}