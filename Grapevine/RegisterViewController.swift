//
//  RegisterViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/5/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide password input
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true
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
    
    @IBAction func registerNewUser(sender: AnyObject) {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
//        let confirmPassword = confirmPasswordField.text!
        
        let newUser = PFUser()
        newUser.username = email
        newUser.password = password
        newUser.setValue(name, forKey: "name")
        
        newUser.signUpInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            // Successfully created a new User
            if (error == nil) {
                self.performSegueWithIdentifier("goToUserSwipeView", sender: sender)
                return
            }
            // Failed to create a new User
            else {
    
            }
        })
    }

}
