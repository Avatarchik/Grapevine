//
//  ViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/4/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide password input
        passwordField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: AnyObject) {
        let username = emailField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsernameInBackground(username, password: password, block:{
            (user: PFUser?, error: NSError?) -> Void in
            // Login SUCESS
            if (user != nil && PFUser.currentUser() != nil) {
                self.performSegueWithIdentifier("goToUserSwipeView", sender: self)
            }
            // Login FAIL
            else {
                let alertController : UIAlertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func goToRegistrationPage(sender: AnyObject) {
        self.performSegueWithIdentifier("goToRegistrationView", sender: self)
    }
}

