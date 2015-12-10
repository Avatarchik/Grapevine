//
//  ProfileViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/6/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userPhoto: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        setUserNameAndPhoto()
        
        addEventButton.layer.cornerRadius = 5
        addEventButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        myEventsButton.layer.cornerRadius = 5
        myEventsButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        logoutButton.layer.cornerRadius = 5
        logoutButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUserNameAndPhoto() {
        let currentUser = PFUser.currentUser()
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", equalTo: (currentUser?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        // Show user name on profile view
                        let userName = object.objectForKey("name") as! String?
                        self.nameLabel.text = userName
                        
                        // Show user photo on profile view
                        let userPhotoFile = object.objectForKey("userPhoto") as! PFFile?
                        self.userPhoto.file = userPhotoFile
                        self.userPhoto.loadInBackground()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let logoutAlert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (action: UIAlertAction!) in
            // Cancel logout action
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: {
            (action: UIAlertAction!) in
            PFUser.logOut()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(logoutAlert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

}
