//
//  HostTableViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/10/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class HostTableViewController: UITableViewController {
    
    var hostEventsArray: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        self.tableView.separatorColor = UIColor(red: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.5, alpha: 1.0)
        
        getBucketEventsDataFromParse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Retrieve all events from Parse that the current user expressed their interest to attend
    func getBucketEventsDataFromParse() {
        let bucketEventIDsQuery = PFQuery(className: "UserEvent")
        bucketEventIDsQuery.whereKey("category", equalTo: "host")
        //        let user = PFUser.currentUser()?.objectId
        let user = "cTbNUaHHRV"
        bucketEventIDsQuery.whereKey("userID", equalTo: user)
        
        bucketEventIDsQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) events in the bucket.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        // add this objectID to the bucketEventIDsArray
                        let id = object["eventID"] as! String
                        self.getEventWithID(id)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getEventWithID(id: String) {
        let getEventQuery = PFQuery(className: "Event")
        getEventQuery.getObjectInBackgroundWithId(id) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                if let event = object {
                    let newEvent = Event()
                    newEvent.objectID = event.objectId!
                    newEvent.objectID = event.objectId!
                    newEvent.eventName = event["EventName"] as? String
                    newEvent.location = event["location"] as? String
                    newEvent.hostedBy = event["hostedBy"] as? String
                    newEvent.start = event["start"] as? NSDate
                    newEvent.end = event["end"] as? NSDate
                    newEvent.eventDescription = event["description"] as? String
                    let imageFile = event["eventPhoto"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                let image = UIImage(data:imageData)
                                newEvent.eventPhoto = image!
                            }
                        }
                    }
                    self.hostEventsArray.append(newEvent)
                }
                self.tableView.reloadData()
            } else {
                print(error)
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
        return hostEventsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HostEventCell") as? HostEventTableViewCell ?? HostEventTableViewCell()
        
        let event = hostEventsArray[indexPath.row] as Event
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
        backItem.title = "Settings"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToHostEventDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let event = hostEventsArray[indexPath.row] as Event
                (segue.destinationViewController as! HostEventDetailsViewController).detailItem = event
            }
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
