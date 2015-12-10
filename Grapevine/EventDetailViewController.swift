//
//  EventDetailViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/6/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import EventKit
import Parse

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventPhotoView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var addToCalButton: UIButton!
    
    var savedEventId : String = ""

    var eventDateFormatter = NSDateFormatter()
    var eventTimeFormatter = NSDateFormatter()
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Event = self.detailItem {
            if let eventName = self.eventNameLabel {
                eventName.text = detail.eventName
            }
            if let hostedBy = self.hostedByLabel {
                hostedBy.text = detail.hostedBy
            }
            if let eventDate = self.eventDateLabel {
                eventDate.text = eventDateFormatter.stringFromDate(detail.start!)
            }
            if let start = self.startTimeLabel {
                start.text = eventTimeFormatter.stringFromDate(detail.start!).lowercaseString
            }
            if let location = self.locationLabel {
                location.text = detail.location
            }
            if let eventDescription = self.descriptionView {
                eventDescription.text = detail.eventDescription
            }
            if let eventPhoto = self.eventPhotoView {
                eventPhotoView.image = detail.eventPhoto
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        addToCalButton.layer.cornerRadius = 5
        addToCalButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        
        eventDateFormatter.dateFormat = "MMMM d"
        eventTimeFormatter.dateFormat = "h:mma"
                
        eventPhotoView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        self.configureView()
        
//        getEventsDataFromParse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func nextButtonClicked() {
//        arrayIndex++;
//        displayEvent()
//    }
    
    // Responds to button to add event. This checks that we have permission first, before adding the
    // event
    @IBAction func addEventToCal(sender: UIButton) {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: (self.detailItem?.eventName)!, startDate: (self.detailItem?.start)!, endDate: (self.detailItem?.end)!)
            })
        } else {
            self.createEvent(eventStore, title: (self.detailItem?.eventName)!, startDate: (self.detailItem?.start)!, endDate: (self.detailItem?.end)!)
        }
    }

    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate

        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
        
        let alertController = UIAlertController(title: "Event Saved!", message: "Your event has been saved to your iCalendar.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
}
