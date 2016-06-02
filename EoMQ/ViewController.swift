//
//  ViewController.swift
//  EoMQ
//
//  Created by Roma on 28/04/2016.
//  Copyright © 2016 esenruma. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    var resultsList : [Results] = []
    
    @IBOutlet var randomTypeLabel: UILabel!
    
    var audioPlayer : AVAudioPlayer?
    
    // Animation 2 Yellow lines
    @IBOutlet var lineImage_1: UIImageView!
    @IBOutlet var lineImage_2: UIImageView!
    
    
// -----------Vertical Lines Animation----------
    override func viewDidLayoutSubviews() {
        // Lines
        self.lineImage_1.center = CGPointMake(self.lineImage_1.center.x + 700, self.lineImage_1.center.y)
        self.lineImage_2.center = CGPointMake(self.lineImage_2.center.x - 700, self.lineImage_2.center.y)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.9) {
            // Lines
            self.lineImage_1.center = CGPointMake(self.lineImage_1.center.x - 700, self.lineImage_1.center.y)
            self.lineImage_2.center = CGPointMake(self.lineImage_2.center.x + 700, self.lineImage_2.center.y)
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
    @IBAction func settingsButton(sender: AnyObject) {
        
        clickSound()
        
        performSegueWithIdentifier("toSettings", sender: self)
    }
    
// ---------------------------------------
    @IBAction func startButton(sender: AnyObject) {
        
        clickSound()
        
        questionsListNumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100"] // Total and exact in CoreD
        randomRange = 100 // 0 indx - 99 indx = 100 // ...to match CoreD list of no.s // match index in "questionsListNumbers"
        
        performSegueWithIdentifier("toQuestions", sender: self)
    }
    
// ---------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! CustomCell
        
        let accessToEntity = self.resultsList[indexPath.row]
        
        cell.nameLabelCustom.text = accessToEntity.name
        cell.imageViewCustom?.image = UIImage(data: accessToEntity.photo!)
        
        let correct = accessToEntity.percentCorrect
        let totalQ = accessToEntity.totalAnswered
        cell.resultsLabelCustom.text = "\(correct!) out of \(totalQ!) Questions!"
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            context.deleteObject(self.resultsList[indexPath.row]) // Always before as CoreD
            self.resultsList.removeAtIndex(indexPath.row)
            
                do {
                    try context.save()
                } catch {
                    print("Error unable to save Deletion")
                }
        } // end IF EditingStyle
        
        self.tableView.reloadData()
    }
    
// ---------------------------------------
    override func viewWillAppear(animated: Bool) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Results")
        request.returnsObjectsAsFaults = false
        
        // ** SORT - High to Low **
        let sortDescriptor = NSSortDescriptor(key: "percentCorrect", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                self.resultsList = results as! [Results]
            }
            
        } catch {
            print("Unable to Fetch 'Results' Entity")
        }
        
        // Refresh TAble
        self.tableView.reloadData()
        
        // -------Rn 'Type' Label-------------
        if pickerSelection == 0 {
            self.randomTypeLabel.text = "General Random\nOption Selected"
        } else if pickerSelection == 1 {
            self.randomTypeLabel.text = "Random(-)Previous\nOption Selected"
        }
        
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








