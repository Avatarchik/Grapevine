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

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.contentMode = .ScaleAspectFit
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        
        // Hide password input
        passwordField.secureTextEntry = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

