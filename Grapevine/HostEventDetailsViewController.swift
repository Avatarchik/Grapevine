//
//  HostEventDetailsViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/10/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit

class HostEventDetailsViewController: UIViewController {

    @IBOutlet weak var eventPhotoView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostedByLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
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
        
        eventDateFormatter.dateFormat = "MMMM d"
        eventTimeFormatter.dateFormat = "h:mma"
        
        eventPhotoView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
