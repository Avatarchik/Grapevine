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

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCalButton: UIButton!
    @IBOutlet weak var eventPhotoView: UIImageView!
    
    var savedEventId : String = ""
    var arrayIndex : Int = 0
    var eventsArray: [Event] = []
    var dateFormatter = NSDateFormatter()
    
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
            if let start = self.startTimeLabel {
                start.text = detail.start.description
            }
            if let location = self.locationLabel {
                location.text = detail.location
            }
            if let description = self.descriptionLabel {
                description.text = detail.description
            }
            if let eventPhoto = self.eventPhotoView {
                eventPhotoView.image = detail.eventPhoto
                print (eventPhoto)
                print (eventPhotoView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        addToCalButton.layer.cornerRadius = 5
        addToCalButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        // sets the display date format for the dateformatter, used for all dates with the stringFromDate method
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        
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
    
//    func displayEvent() {
//        if (arrayIndex < self.eventsArray.count) {
//            eventNameLabel.text = self.eventsArray[arrayIndex].eventName
//            hostedByLabel.text = self.eventsArray[arrayIndex].hostedBy
//            startTimeLabel.text = dateFormatter.stringFromDate(self.eventsArray[arrayIndex].start)
//            locationLabel.text = self.eventsArray[arrayIndex].location
//            descriptionLabel.text = self.eventsArray[arrayIndex].description
//        } else {
//            let alertController = UIAlertController(title: "No more events to display", message: "There are no more events. Check back in a few hours for more!", preferredStyle: .Alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alertController.addAction(defaultAction)
//            
//            presentViewController(alertController, animated: true, completion: nil)
//        }
//    }

}
