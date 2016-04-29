//
//  ResultsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet var totQsLabel: UILabel!
    
    @IBOutlet var totCorrectLabel: UILabel!
    
    @IBOutlet var correctPercentageLabel: UILabel!

    @IBOutlet var nameTextLabel: UITextField!
    
    @IBOutlet var imageView: UIImageView!
 
// ---------------------------------------
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
// ---------------------------------------
    @IBAction func getCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
    @IBAction func getPhoto(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
// ---------------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
// ---------------------------------------
    @IBAction func saveResultsButton(sender: AnyObject) {
        // Save to CoreD
        if self.nameTextLabel == nil || self.imageView == nil {
            noNameAlert()
            
        } else {
            // do CoreD Saving
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            let newSave = NSEntityDescription.insertNewObjectForEntityForName("Results", inManagedObjectContext: context) as! Results
            
            newSave.name = self.nameTextLabel.text
            newSave.totalAnswered = self.totQsLabel.text
            newSave.percentCorrect = self.correctPercentageLabel.text
            newSave.photo = UIImageJPEGRepresentation(self.imageView!.image!, 1.0)
            
            do {
                try context.save()
                print("saved!!! + Go To home screen")
                
            } catch {
                print("Error Saving Results")
            }
            
            // Reset Score on Questions VC
            totalQuestions = 0
            totalCorrects = 0
            
            // Reset Results Labels to Nil
            self.totQsLabel.text = ""
            self.totCorrectLabel.text = ""
            self.correctPercentageLabel.text = ""
            self.nameTextLabel.text = ""
            self.imageView.image = UIImage()
            
            // GoTo Home Screen
            performSegueWithIdentifier("resultsToHome", sender: self)
            
        } // end IF
    } // end func
    
// ---------------------------------------
    func noNameAlert() {
        let alert = UIAlertController(title: "ALERT", message: "Please enter a Name & Photo", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        self.totQsLabel.text = String(totalQuestions)
        self.totCorrectLabel.text = String(totalCorrects)
        
        // calc. percentage correct
        let percCalc = (Double(totalCorrects) / Double(totalQuestions)) * 100
        self.correctPercentageLabel.text = "\(Int(percCalc))%"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
