//
//  SettingsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var resultsLabel: UILabel!
    
    var randomSelectionList = ["General Random", "Random (minus) Previsou", "In Order"]
    
    var pickerSelection = 0
    
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
        self.pickerSelection = row
    }
    
// ---------------------------------------
    @IBAction func selectButton(sender: AnyObject) {
        
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
