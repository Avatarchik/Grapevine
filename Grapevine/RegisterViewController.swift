//
//  RegisterViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/5/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    var activeField: UITextField?
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var loginViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 375.0, height: 672.0)
        
        self.view.backgroundColor = UIColor(red: 231.0/255.0, green: 232.0/255.0, blue: 233.0/255.5, alpha: 1.0)
        logoImageView.contentMode = .ScaleAspectFit
        createUserButton.layer.cornerRadius = 5
        createUserButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        loginViewButton.titleLabel?.textColor = UIColor(red: 83.0/255.0, green: 81.0/255.0, blue: 127.0/255.5, alpha: 1.0)
        
        // Hide password input
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        registerForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
