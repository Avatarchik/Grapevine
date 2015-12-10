//
//  BucketTableViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/6/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class BucketTableViewController: UITableViewController {
    
    var eventsArray: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        self.tableView.separatorColor = UIColor(red: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.5, alpha: 1.0)
        getAllEvents()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getAllEvents() {
        let query = PFQuery(className:"Event")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let newEvent = Event()
                        newEvent.objectID = object.objectId!
                        newEvent.eventName = object["EventName"] as? String
                        newEvent.hostedBy = object["hostedBy"] as? String
                        newEvent.location = object["location"] as? String
                        newEvent.start = object["start"] as? NSDate
                        newEvent.end = object["end"] as? NSDate
                        newEvent.eventDescription = object["description"] as? String
                        let imageFile = object["eventPhoto"] as! PFFile
                        imageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    let image = UIImage(data:imageData)
                                    newEvent.eventPhoto = image!
                                }
                            }
                        }
                        
                        self.eventsArray.append(newEvent)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as? EventTableViewCell ?? EventTableViewCell()
        
        let event = eventsArray[indexPath.row] as Event
        cell.eventNameLabel.text = event.eventName

        let dateString = event.convertEventDateFormatter(event.start!)
        cell.eventDateLabel.text = dateString
        
        let timeString = event.convertEventTimeFormatter(event.start!)
        cell.eventTimeLabel.text = timeString
        
        cell.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Bucket"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToEventDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let event = eventsArray[indexPath.row] as Event
                (segue.destinationViewController as! EventDetailViewController).detailItem = event
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
