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

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var loginViewLabel: UILabel!
    @IBOutlet weak var loginViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 231.0/255.0, green: 232.0/255.0, blue: 233.0/255.5, alpha: 1.0)
        logoImageView.contentMode = .ScaleAspectFit
        createUserButton.layer.cornerRadius = 5
        createUserButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        loginViewLabel.textColor = UIColor(red: 83.0/255.0, green: 81.0/255.0, blue: 127.0/255.5, alpha: 1.0)
        loginViewButton.titleLabel?.textColor = UIColor(red: 83.0/255.0, green: 81.0/255.0, blue: 127.0/255.5, alpha: 1.0)
        
        // Hide password input
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            }
            // Failed to create a new User
            else {
    
            }
        })
    }
    
    @IBAction func goToLoginViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
