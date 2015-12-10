//
//  AddEventViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/9/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var activeField: UITextField?
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var hostedBy: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addEventPhotoButton: UIButton!
    @IBOutlet weak var createNewEventButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var dateFormatter = NSDateFormatter()
    
    let datePickerView = UIDatePicker()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 375.0, height: 672.0)
        
        self.view.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        addEventPhotoButton.titleLabel?.textColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        createNewEventButton.layer.cornerRadius = 5
        createNewEventButton.backgroundColor = UIColor(red: 126.0/255.0, green: 67.0/255.0, blue: 150.0/255.5, alpha: 1.0)
        
        imagePicker.delegate = self
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        
        eventName.delegate = self
        hostedBy.delegate = self
        startTextField.delegate = self
        endTextField.delegate = self
        location.delegate = self
        descriptionField.delegate = self
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        startTextField.inputView = datePickerView
        endTextField.inputView = datePickerView
        
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
    
    @IBAction func addImageButtonTapped() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startTextFieldEditing(sender: UITextField) {
        datePickerView.addTarget(self, action: Selector("startPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func endTextFieldEditing(sender: UITextField) {
        datePickerView.addTarget(self, action: Selector("endPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func hostCreateEvent(sender: UIButton) {
        // Create a parse object
        let eventObject = PFObject(className: "Event")
        
        // all string attributes
        eventObject["EventName"] = eventName.text
        eventObject["hostedBy"] = hostedBy.text
        eventObject["location"] = location.text
        eventObject["description"] = descriptionField.text
        
        // saving the photo file
        let photo = imageView.image!
        let eventImageData = UIImageJPEGRepresentation(photo, 0.5)
        let file = PFFile(name: eventName.text! + "Photo.png", data: eventImageData!)
        file!.saveInBackground()
        eventObject["eventPhoto"] = file
        
        // save the start time and end time
        let startNSDate = dateFormatter.dateFromString(startTextField.text!)
        let endNSDate = dateFormatter.dateFromString(endTextField.text!)
        eventObject["start"] = startNSDate
        eventObject["end"] = endNSDate
        eventObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("New event object has been saved.")
        }
        
        let alertController = UIAlertController(title: "Event has been posted!", message: "Your created event will be seen by Grapevine users.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {
            action in self.navigationController?.popViewControllerAnimated(true)
        })
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func startPickerValueChanged(sender:UIDatePicker) {
        startTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func endPickerValueChanged(sender:UIDatePicker) {
        endTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}