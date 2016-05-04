//
//  SettingsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

var pickerSelection = 0 // Set as Default Gen. Random 

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {

    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var resultsLabel: UILabel!
    
    var randomSelectionList = ["General Random", "Random (minus) Previous"]
    
    
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
                self.resultsLabel.text = "''Random (minus) Previous'' \n Option has been selected. \n Goto to Home page to start"
            
        } // end If
    }
    
// ---------------------------------------
    @IBAction func homeButton(sender: AnyObject) {
        performSegueWithIdentifier("settingToHome", sender: self)
    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize.height = 667
        

        // works to Add Image to Bar Button Item
//        let homeImage = UIImage(named: "Home icon 40px")
//        self.backButton.setBackgroundImage(homeImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default) // sets image to LT Bar Button Item: "button" = LEFT only
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}














