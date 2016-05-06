//
//  SettingsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


var pickerSelection = 0 // Set as Default Gen. Random 

var soundAnimationOption = 0

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {

    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var resultsLabel: UILabel!
    
    @IBOutlet var pendingLabel: UILabel!
    
    var randomSelectionList = ["General Random", "Random (minus) Previous"]
    
    var audioPlayer : AVAudioPlayer?
    
    @IBOutlet var soundChoiceLabel: UILabel!
    
    
// ---------------------------------------
    func clickSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Click", ofType: "wav")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
                
            } catch {
                print("Unable to play 'Click' Sound!!")
            } // end do-try-catch
        } // End If on sound animation
    }
    
// ---------------------------------------
    func alertSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("Alert_2secs", ofType: "m4a")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
            } catch {
                print("Unable to Play Sound!!")
            } // end do-try-catch
        } // End IF on sound animation
    }
    
// ---------------------------------------
    @IBAction func soundOnOffButton(sender: AnyObject) {
        
        clickSound()
        
        // Default = off = 0 // (on = 1)
        // switch btn 0/Off and 1/On
        
        if soundAnimationOption == 0 {
            soundAnimationOption = 1
            
        } else if soundAnimationOption == 1 {
            soundAnimationOption = 0
        }
        
        // update message
        soundLabelMessage()
        
        // Check if Working
        print(soundAnimationOption)
    }
    
// ---------------------------------------
    func soundLabelMessage() {
        
        if soundAnimationOption == 0 {
            self.soundChoiceLabel.text = "Off"
            
        } else if soundAnimationOption == 1 {
            self.soundChoiceLabel.text = "On"
        }
    }
    
// ---------------------------------------
    @IBAction func resetScoresButton(sender: AnyObject) {
        
        clickSound()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Results")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                // ** Something to Delete = Alert to Check if SURE? **
                let alert = UIAlertController(title: "Deleting ALL Scores", message: "Are you sure?", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }
                
                let deleteAction = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    
                    self.resetDeleteAll() // call this func
                }
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                // ** Make Alert Sound **
                alertSound()
                
            } else {
                // ** Nothing to Delete = Alert to inform = nothing there
                let alert = UIAlertController(title: "Alert", message: "Nothing to Delete", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }
                
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                // ** Make Alert Sound **
                alertSound()
                
            } // End IF
            
        } catch {
        } // end Do-Try-Catch
        
    } // End Func
    
    // ------------Deleting from CoreData 'Results'------------------------------------
    func resetDeleteAll() {
        
        clickSound()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Results")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result: AnyObject in results {
                    
                    context.deleteObject(result as! NSManagedObject)
                    
                    print("NSManagedObject has been Deleted")
                    
                    self.pendingLabel.text! = "ALL DELETED!!!"
                }
                try context.save() }
        } catch {
            print("Unable to Delete all Scores from Results")
        }
    }
    
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
        
        clickSound()
        
        // picker selection
        if pickerSelection == 0 {
            self.resultsLabel.text = "''General Random'' Option Selected"
            
            } else if pickerSelection == 1 {
                self.resultsLabel.text = "''Random (minus) Previous'' \n Option Selected"
            
        } // end If
    }
    
// ---------------------------------------
    @IBAction func homeButton(sender: AnyObject) {
        
        clickSound()
        
        performSegueWithIdentifier("settingToHome", sender: self)
    }
    
// ---------------------------------------
    override func viewWillAppear(animated: Bool) {
        // update Animated Sound Message
        soundLabelMessage()
    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize.height = 667
        
        // update Animated Sound Message
        soundLabelMessage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}














