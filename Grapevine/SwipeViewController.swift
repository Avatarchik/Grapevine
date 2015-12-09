//
//  SwipeViewController.swift
//  Grapevine
//
//  Created by Jenny Yang on 12/5/15.
//  Copyright © 2015 Jenny Yang. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIViewController {
    
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var bucketButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
        
        let settingsButtonView = UIButton()
        settingsButtonView.setImage(UIImage(named: "settings_button"), forState: .Normal)
        settingsButtonView.frame = CGRectMake(0, 0, 30, 30)
        settingsButtonView.addTarget(self, action: Selector("goToSettingsView"), forControlEvents: .TouchUpInside)
        settingsButton.customView = settingsButtonView
        
        let bucketButtonView = UIButton()
        bucketButtonView.setImage(UIImage(named: "bucket_button"), forState: .Normal)
        bucketButtonView.frame = CGRectMake(0, 0, 30, 30)
        bucketButtonView.addTarget(self, action: Selector("goToBucketView"), forControlEvents: .TouchUpInside)
        bucketButton.customView = bucketButtonView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToSettingsView() {
        self.performSegueWithIdentifier("goToSettingsView", sender: nil)
    }
    
    func goToBucketView() {
        self.performSegueWithIdentifier("goToBucketView", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

}
