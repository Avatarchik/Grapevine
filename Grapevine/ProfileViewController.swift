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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
