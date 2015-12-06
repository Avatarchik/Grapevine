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
        // Do any additional setup after loading the view, typically from a nib.
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToRegistrationPage(sender: AnyObject) {
        self.performSegueWithIdentifier("goToRegistrationPage", sender: self)
    }
}

