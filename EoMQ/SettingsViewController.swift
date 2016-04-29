//
//  SettingsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    
    
    
    
// ---------------------------------------
    @IBAction func cancelButtonSettings(sender: AnyObject) {
        performSegueWithIdentifier("settingToHome", sender: self)
    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
