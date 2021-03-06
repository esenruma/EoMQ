//
//  ResultsViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ResultsViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {

    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var totQsLabel: UILabel!
    
    @IBOutlet var totCorrectLabel: UILabel!
    
    @IBOutlet var correctPercentageLabel: UILabel!

    @IBOutlet var nameTextLabel: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var redButton: UIButton!
    
    var audioPlayer : AVAudioPlayer?
    
    // Yellow line Animation
    @IBOutlet weak var leftYellowLine: UIImageView!
    @IBOutlet weak var rightYellowLine: UIImageView!
    
// ---------------------------------------
    override func viewDidLayoutSubviews() {
        // Lines
        self.leftYellowLine.center = CGPointMake(self.leftYellowLine.center.x + 700, self.leftYellowLine.center.y)
        self.rightYellowLine.center = CGPointMake(self.rightYellowLine.center.x - 700, self.rightYellowLine.center.y)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.9) {
            // Lines
            self.leftYellowLine.center = CGPointMake(self.leftYellowLine.center.x - 700, self.leftYellowLine.center.y)
            self.rightYellowLine.center = CGPointMake(self.rightYellowLine.center.x + 700, self.rightYellowLine.center.y)
        }
    }

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
                print("Unable to play 'Alert_2secs' Sound!!")
            } // end do-try-catch
        } // End If on sound animation
    }
    
// ---------------------------------------
    func thoughtSound() {
        if soundAnimationOption == 1 {
            do {
                let path = NSBundle.mainBundle().pathForResource("thought_sounds_1sec", ofType: "m4a")
                let url = NSURL(fileURLWithPath: path!)
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer!.play()
            } catch {
                print("Unable to Play Sound!!")
            } // end do-try-catch
        } // end IF on sound animation
    }
    
// ---------------------------------------
    @IBAction func homeButton(sender: AnyObject) {
        clickSound()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
// ---------------------------------------
    @IBAction func getCamera(sender: AnyObject) {
        
        clickSound()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let img = UIImagePickerController()
            img.delegate = self
            img.sourceType = UIImagePickerControllerSourceType.Camera
            img.allowsEditing = false
            self.presentViewController(img, animated: true, completion: nil)
        }
    }
    
    @IBAction func getPhoto(sender: AnyObject) {
        
        clickSound()
        
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
   
// ------------Keyboard---------------
    // In scrollView.... - Work with 'TapGesture' in 'ViewDidLoad'
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
// ---------------------------------------
    @IBAction func saveResultsButton(sender: AnyObject) {
        // Save to CoreD
        if self.nameTextLabel.text == "" {
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
            
            // Reset Score on Questions VC-Global
            totalQuestions = 0
            totalCorrects = 0
            
            // Reset Results Labels to Nil
            self.totQsLabel.text = ""
            self.totCorrectLabel.text = ""
            self.correctPercentageLabel.text = ""
            self.nameTextLabel.text = ""
            // self.imageView.image = UIImage() // ** No Need?? **
            
            // ** Make 'mmm' Sound **
            thoughtSound()
            
            // GoTo Home Screen
            performSegueWithIdentifier("resultsToHome", sender: self)
            
        } // end IF
    } // End FUNC
    
// ---------------------------------------
    func noNameAlert() {
        let alert = UIAlertController(title: "ALERT", message: "Please enter a Name", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        // ** Make Alert Sound **
        alertSound()

    }
    
// ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // -----red Button Txt Alignment -----
        self.redButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        // -----Keyboard Behaviour-----
        let tap = UITapGestureRecognizer(target: self, action: #selector(ResultsViewController.dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
        
        // ----------------------------
        self.totQsLabel.text = String(totalQuestions)
        self.totCorrectLabel.text = String(totalCorrects)
        
        // calc. percentage correct
        let percCalc = (Double(totalCorrects) / Double(totalQuestions)) * 100
        self.correctPercentageLabel.text = "\(Int(percCalc))%"
        
        // ScrollView
        self.scrollView.contentSize.height = 667
        
        // *** modify textField **
        self.nameTextLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.nameTextLabel.layer.borderWidth = 1.0
        self.nameTextLabel.layer.cornerRadius = 8.0
        self.nameTextLabel.attributedPlaceholder = NSAttributedString(string:"Enter name...", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
