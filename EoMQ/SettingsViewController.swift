//
//  SettingsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

var pickerSelection = 0

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var resultsLabel: UILabel!
    
    var randomSelectionList = ["General Random", "Random (minus) Previous", "In Order"]
    
    
    
// ---------------------------------------
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.randomSelectionList.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.randomSelectionList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = row
    }
    
// ---------------------------------------
    @IBAction func selectButton(sender: AnyObject) {
        print(pickerSelection)
        
        if pickerSelection == 0 {
            self.resultsLabel.text = "''Genernal Random'' Option has been selected. \n Goto to Home page to start"
        } else if pickerSelection == 1 {
            self.resultsLabel.text = "''Random (minus) Previous'' Option has been selected. \n Goto to Home page to start"
        } else if pickerSelection == 2 {
            self.resultsLabel.text = "''In Order'' Option has been selected. \n Goto to Home page to start"
        }
        
    }
    
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
