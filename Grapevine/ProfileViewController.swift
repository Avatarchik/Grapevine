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

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userPhoto: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserNameAndPhoto()
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
