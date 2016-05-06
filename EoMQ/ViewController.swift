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
        
        questionsListNumbers = ["1", "2", "3", "4", "5"] // Total and exact in CoreD
        randomRange = 5 // 0 - 4 = 5 // no incl. 5 .. to match CoreD list of no.s // match index in "questionsListNumbers" 
        
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
            self.randomTypeLabel.text = "Genernal Random \n Option Selected"
        } else if pickerSelection == 1 {
            self.randomTypeLabel.text = "Random (minus)Previous \n Option Selected"
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








